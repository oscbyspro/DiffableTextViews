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
        var instance = Self(); instance.integer = .zero; return instance
    }()
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=

    @usableFromInline private(set) var sign = Sign()
    @usableFromInline private(set) var integer = Digits()
    @usableFromInline private(set) var separator = Separator()
    @usableFromInline private(set) var fraction = Digits()
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() { }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func characters() -> String {
        var characters = String()
        sign.write(to: &characters)
        integer.write(to: &characters)
        separator.write(to: &characters)
        fraction.write(to: &characters)
        return characters
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

        while index != snapshot.endIndex, let digit = region.digits[element.character] {
            instance.integer.append(digit)
            iterate()
        }
        
        instance.integer.replaceEmptyWithZero()
        
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
        // MARK: Done
        //=--------------------------------------=
        
        return instance
    }
}
