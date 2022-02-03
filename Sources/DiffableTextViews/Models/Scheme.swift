//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Scheme
//*============================================================================*

@usableFromInline protocol Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Size
    //=------------------------------------------------------------------------=
    
    @inlinable static func size(of character: Character) -> Int
    
    @inlinable static func size<S: StringProtocol>(of characters: S) -> Int
}

//*============================================================================*
// MARK: * Character
//*============================================================================*

extension Character: Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Size
    //=------------------------------------------------------------------------=

    @inlinable static func size(of character: Character) -> Int { 1 }
    
    @inlinable static func size<S: StringProtocol>(of characters: S) -> Int {
        characters.count
    }
}

//*============================================================================*
// MARK: * UTF8
//*============================================================================*

extension UTF8: Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Size
    //=------------------------------------------------------------------------=

    @inlinable static func size(of character: Character) -> Int {
        character.utf8.count
    }
    
    @inlinable static func size<S: StringProtocol>(of characters: S) -> Int {
        characters.utf8.count
    }
}

//*============================================================================*
// MARK: * UTF16
//*============================================================================*

extension UTF16: Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Size
    //=------------------------------------------------------------------------=

    @inlinable static func size(of character: Character) -> Int {
        character.utf16.count
    }
    
    @inlinable static func size<S: StringProtocol>(of characters: S) -> Int {
        characters.utf16.count
    }
}

//*============================================================================*
// MARK: * UnicodeScalar
//*============================================================================*

extension UnicodeScalar: Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Size
    //=------------------------------------------------------------------------=

    @inlinable static func size(of character: Character) -> Int {
        character.unicodeScalars.count
    }
    
    @inlinable static func size<S: StringProtocol>(of characters: S) -> Int {
        characters.unicodeScalars.count
    }
}
