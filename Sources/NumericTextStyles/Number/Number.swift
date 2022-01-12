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
    
    /// Parses the value represented by a snapshot.
    ///
    /// To use this method, all formatting characters must be marked as formatting.
    ///
    @inlinable init(_ snapshot: Snapshot, with options: Options, in region: Region) throws {
        guard let start = snapshot.firstIndex(where: \.nonformatting) else { self = .zero; return }
        
        //=--------------------------------------=
        // MARK: State
        //=--------------------------------------=
        
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
        
        attempt: do {

            //=----------------------------------=
            // MARK: Sign
            //=----------------------------------=

            if index != snapshot.endIndex, !options.contains(.unsigned), let sign = region.signs[element.character] {
                self.sign = sign
                iterate()
            }

            //=----------------------------------=
            // MARK: Digits
            //=----------------------------------=

            while index != snapshot.endIndex, let digit = region.digits[element.character] {
                self.integer.append(digit)
                iterate()
            }
            
            self.integer.removeZerosPrefix()
            self.integer.makeItAtLeastZero()
            
            guard !options.contains(.integer) else { break attempt }
            
            //=----------------------------------=
            // MARK: Separator
            //=----------------------------------=

            if index != snapshot.endIndex, region.fractionSeparator == element.character {
                self.separator = .some
                iterate()
            }
            
            guard self.separator == .some else { break attempt }
            
            //=----------------------------------=
            // MARK: Fraction
            //=----------------------------------=
            
            while index != snapshot.endIndex, let digit = region.digits[element.character] {
                self.fraction.append(digit)
                iterate()
            }
            
        }
        
        //=--------------------------------------=
        // MARK: Validate
        //=--------------------------------------=
        
        guard index == snapshot.endIndex else {
            throw Info(["unable to parse number in", .mark(snapshot.characters)])
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Number - CustomStringConvertible
//=----------------------------------------------------------------------------=

extension Number: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable var description: String {
        characters()
    }
}
