//
//  Unicodeable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-16.
//

//*============================================================================*
// MARK: * Unicodeable
//*============================================================================*

/// The unicode value of its system representation.
@usableFromInline protocol Unicodeable:
RawRepresentable, CaseIterable, CustomStringConvertible where RawValue == UInt8 {
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @inlinable static var characters: [Character: Self] { get }
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
    
    @inlinable static func characters() -> [Character: Self] {
        allCases.reduce(into: [:]) { result, next in result[next.character] = next }
    }
}
