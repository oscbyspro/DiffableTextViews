//
//  Number.swift
//
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import DiffableTextViews

//*============================================================================*
// MARK: * Number
//*============================================================================*

/// A system representation of a number.
@usableFromInline struct Number {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let zero: Self = {
        var instance = Self(); instance.integer = [.x0]; return instance
    }()
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=

    @usableFromInline private(set) var sign = Sign()
    @usableFromInline private(set) var integer = [Digit]()
    @usableFromInline private(set) var separator = Separator()
    @usableFromInline private(set) var fraction = [Digit]()
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() { }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func characters() -> String {
        var result = ""
        result += sign.rawValue
        for digit in integer  { result += digit.rawValue }
        result += separator.rawValue
        for digit in fraction { result += digit.rawValue }
        return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: Number - Parse
//=----------------------------------------------------------------------------=

extension Number {
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    @inlinable static func parse(_ snapshot: Snapshot, with options: Options, in region: Region) throws -> Self {
        guard let start = snapshot.firstIndex(where: \.nonformatting) else { return .zero }
        
        //=--------------------------------------=
        // MARK: State
        //=--------------------------------------=
        
        var instance = Self()
        var index = start
        var element = snapshot[start]
        
        //=--------------------------------------=
        // MARK: Helpers
        //=--------------------------------------=

        func iterate() {
            while index != snapshot.endIndex {
                snapshot.formIndex(after: &index)
                element = snapshot[index]
                if element.nonformatting { break }
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

        while index != snapshot.endIndex, region.digits.contains(element.character) {
            instance.integer.append(element.character)
            iterate()
        }
        
        if instance.integer.isEmpty { instance.integer = "0" }
        
        guard !options.contains(.integer) else { return instance }
        
        //=--------------------------------------=
        // MARK: Separator
        //=--------------------------------------=

        if index != snapshot.endIndex, region.fractionSeparator == element.character {
            instance.separator = true
            iterate()
        }
        
        guard instance.separator else { return instance }
        
        //=--------------------------------------=
        // MARK: Fraction
        //=--------------------------------------=
        
        while index != snapshot.endIndex, region.digits.contains(element.character) {
            instance.integer.append(element.character)
            iterate()
        }
        
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        
        return instance
    }
}
