//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Position
//*============================================================================*

/// A model that represents the position in text, according to its text scheme.
///
/// Text views are not usually based on characters. UITextField counts its positions in UTF16 units, for example.
/// This destinction is important because emojis are one character in size but sometimes mutlitple UTF16 units,
/// and if this is not aknowledged you may try to access positions out of bounds and crash the application.
///
public struct Position<Scheme: DiffableTextKit.Scheme>: Comparable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @usableFromInline let offset: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ offset: Int = 0) {
        self.offset = offset
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=

    @inlinable static var start: Self {
        Self()
    }
        
    @inlinable static func end<S: StringProtocol>(of characters: S) -> Self {
        Self(Scheme.size(of: characters))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func  after(_ character: Character) -> Self {
        Self(offset + Scheme.size(of: character))
    }
    
    @inlinable func before(_ character: Character) -> Self {
        Self(offset - Scheme.size(of: character))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=

    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.offset == rhs.offset
    }
    
    @inlinable public static func <  (lhs: Self, rhs: Self) -> Bool {
        lhs.offset <  rhs.offset
    }
}
