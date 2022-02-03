//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Unicodeable
//*============================================================================*

/// The unicode value of its system representation.
@usableFromInline protocol Unicodeable:
RawRepresentable, CaseIterable, CustomStringConvertible where RawValue == UInt8 {
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @inlinable static var system: [Character: Self] { get }
}

//=----------------------------------------------------------------------------=
// MARK: Unicodeable - Details
//=----------------------------------------------------------------------------=

extension Unicodeable {
    
    //=------------------------------------------------------------------------=
    // MARK: Unicode
    //=------------------------------------------------------------------------=
    
    @inlinable public var unicode: Unicode.Scalar {
        Unicode.Scalar(rawValue)
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Character
    //=------------------------------------------------------------------------=
    
    @inlinable public var character: Character {
        Character(unicode)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        String(character)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable static func system() -> [Character: Self] {
        allCases.reduce(into: [:]) {
            result,unicodeable in
            result[unicodeable.character] = unicodeable
        }
    }
}
