//
//  Number.swift
//
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import DiffableTextViews
import Utilities

//*============================================================================*
// MARK: * Number
//*============================================================================*

/// A system representation of a number.
@usableFromInline struct Number: Component {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let zero: Self = {
        var instance = Self(); instance.integer = .zero; return instance
    }()
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=

    @usableFromInline var sign = Sign()
    @usableFromInline private(set) var integer = Digits()
    @usableFromInline private(set) var separator = Separator()
    @usableFromInline private(set) var fraction = Digits()
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() { }
    
    //=------------------------------------------------------------------------=
    // MARK: Count
    //=------------------------------------------------------------------------=
        
    @inlinable func significantCount() -> Int {
        let significantIntegerCount = integer.count - integer.prefixZerosCount()
        let significantFractionCount = fraction.count - fraction.suffixZerosCount()
        return significantIntegerCount + significantFractionCount
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func removeImpossibleSeparator(capacity: Capacity) {
        guard fraction.digits.isEmpty else { return }
        guard capacity.fraction <= 0 || capacity.significant <= 0 else { return }
        separator = .none
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Text
    //=------------------------------------------------------------------------=
    
    @inlinable func characters() -> String {
        var characters = ""
        write(to: &characters)
        return characters
    }
    
    @inlinable func write<Stream: TextOutputStream>(to stream: inout Stream) {
        sign.write(to: &stream)
        integer.write(to: &stream)
        separator.write(to: &stream)
        fraction.write(to: &stream)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Number - Parse
//=----------------------------------------------------------------------------=

extension Number {
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    #warning("Document assumptions made.")
    @inlinable static func parse(_ snapshot: Snapshot, with options: Options, in region: Region) throws -> Self {
        guard let start = snapshot.firstIndex(where: \.nonformatting) else { return .zero }
        
        //=--------------------------------------=
        // MARK: State
        //=--------------------------------------=
        
        var instance = Self()
        var index = start
        var element = snapshot[start]
        var done = false
        
        //=--------------------------------------=
        // MARK: Helpers
        //=--------------------------------------=

        func iterate() {
            loop: while !done {
                snapshot.formIndex(after: &index)

                if index != snapshot.endIndex {
                    element = snapshot[index]
                    if element.nonformatting { break loop }
                } else {
                    done = true
                }
            }
        }

        //=--------------------------------------=
        // MARK: Sign
        //=--------------------------------------=

        if index != snapshot.endIndex, !options.contains(.unsigned), let sign = region.signs[element.character] {
            instance.sign = sign
            iterate()
        }

        //=--------------------------------------=
        // MARK: Digits
        //=--------------------------------------=

        while index != snapshot.endIndex, let digit = region.digits[element.character] {
            instance.integer.append(digit)
            iterate()
        }
        
        instance.integer.removeZerosPrefix()
        instance.integer.makeItAtLeastZero()
        
        guard !options.contains(.integer) else { return instance }
        
        //=--------------------------------------=
        // MARK: Separator
        //=--------------------------------------=

        if index != snapshot.endIndex, region.fractionSeparator == element.character {
            instance.separator = .some
            iterate()
        }
        
        guard instance.separator != .none else { return instance }
        
        //=--------------------------------------=
        // MARK: Fraction
        //=--------------------------------------=
        
        while index != snapshot.endIndex, let digit = region.digits[element.character] {
            instance.fraction.append(digit)
            iterate()
        }
        
        //=--------------------------------------=
        // MARK: Validate
        //=--------------------------------------=
        
        guard index == snapshot.endIndex else {
            throw Info(["unable to parse number in", .mark(snapshot.characters)])
        }
        
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        
        return instance
    }
}
