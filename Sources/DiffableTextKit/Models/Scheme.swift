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

@usableFromInline typealias _Scheme = Scheme; public protocol Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Size
    //=------------------------------------------------------------------------=
    
    @inlinable static func size(of character: Character) -> Int
    
    @inlinable static func size<S>(of characters: S) -> Int where S: StringProtocol
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Aliases
    //=------------------------------------------------------------------------=
    
    public typealias Position = DiffableTextKit.Position<Self>
    @usableFromInline typealias Field = DiffableTextKit.Field<Self>
    @usableFromInline typealias Index = DiffableTextKit.Index<Self>
    @usableFromInline typealias Layout = DiffableTextKit.Layout<Self>
}

//*============================================================================*
// MARK: * Scheme x Character
//*============================================================================*

extension Character: Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Size
    //=------------------------------------------------------------------------=

    @inlinable public static func size(of character: Character) -> Int { 1 }
    
    /// - Complexity: O(n).
    @inlinable public static func size<S>(of characters: S) -> Int where S: StringProtocol {
        characters.count
    }
}

//*============================================================================*
// MARK: * Scheme x UTF8
//*============================================================================*

extension UTF8: Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Size
    //=------------------------------------------------------------------------=

    @inlinable public static func size(of character: Character) -> Int {
        character.utf8.count
    }
    
    /// - Complexity: O(1).
    @inlinable public static func size<S>(of characters: S) -> Int where S: StringProtocol {
        characters.utf8.count
    }
}

//*============================================================================*
// MARK: * Scheme x UTF16
//*============================================================================*

extension UTF16: Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Size
    //=------------------------------------------------------------------------=

    @inlinable public static func size(of character: Character) -> Int {
        character.utf16.count
    }
    
    /// - Complexity: O(1).
    @inlinable public static func size<S>(of characters: S) -> Int where S: StringProtocol {
        characters.utf16.count
    }
}

//*============================================================================*
// MARK: * Scheme x UnicodeScalar
//*============================================================================*

extension UnicodeScalar: Scheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Size
    //=------------------------------------------------------------------------=

    @inlinable public static func size(of character: Character) -> Int {
        character.unicodeScalars.count
    }
    
    /// - Complexity: O(n).
    @inlinable public static func size<S>(of characters: S) -> Int where S: StringProtocol {
        characters.unicodeScalars.count
    }
}
