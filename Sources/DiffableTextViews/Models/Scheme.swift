//
//  Scheme.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-23.
//

//*============================================================================*
// MARK: * Scheme
//*============================================================================*

@usableFromInline protocol Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Size
    //=------------------------------------------------------------------------=
    
    @inlinable static func size(of character: Character) -> Int
    @inlinable static func size(of characters:   String) -> Int
}

//*============================================================================*
// MARK: * Character
//*============================================================================*

extension Character: Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Size
    //=------------------------------------------------------------------------=

    @inlinable static func size(of character: Character) -> Int { 1 }
    @inlinable static func size(of characters:   String) -> Int { characters.count }
}

//*============================================================================*
// MARK: * UTF8
//*============================================================================*

extension UTF8: Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Size
    //=------------------------------------------------------------------------=

    @inlinable static func size(of character: Character) -> Int {  character.utf8.count }
    @inlinable static func size(of characters:   String) -> Int { characters.utf8.count }
}

//*============================================================================*
// MARK: * UTF16
//*============================================================================*

extension UTF16: Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Size
    //=------------------------------------------------------------------------=

    @inlinable static func size(of character: Character) -> Int {  character.utf16.count }
    @inlinable static func size(of characters:   String) -> Int { characters.utf16.count }
}

//*============================================================================*
// MARK: * UnicodeScalar
//*============================================================================*

extension UnicodeScalar: Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Size
    //=------------------------------------------------------------------------=

    @inlinable static func size(of character: Character) -> Int {  character.unicodeScalars.count }
    @inlinable static func size(of characters:   String) -> Int { characters.unicodeScalars.count }
}
