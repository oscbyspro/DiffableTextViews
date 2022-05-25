//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Glyph
//*============================================================================*

/// A UTF-8 encoded ASCII character.
@usableFromInline protocol Glyph: Hashable, CaseIterable, CustomStringConvertible {
    associatedtype Enumeration: CaseIterable, RawRepresentable where Enumeration.RawValue == UInt8

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var rawValue: UInt8 { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ enumeration: Enumeration)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
        
    @inlinable func standard(_ formatter: NumberFormatter) -> Character!

    @inlinable func currency(_ formatter: NumberFormatter) -> Character!
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension Glyph {
    
    //=------------------------------------------------------------------------=
    // MARK: Enumeration
    //=------------------------------------------------------------------------=
    
    @inlinable var enumeration: Enumeration {
        Enumeration(rawValue: rawValue)!
    }
    
    @inlinable static var allCases: [Self] {
        Enumeration.allCases.map(Self.init)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Unicodeable
    //=------------------------------------------------------------------------=
    
    @inlinable var unicode: Unicode.Scalar {
        Unicode.Scalar(rawValue)
    }
    
    @inlinable var character: Character {
        Character(unicode)
    }
    
    @inlinable var description: String {
        String(unicode)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func transform(_ transform: (inout Self) -> Void) {
        transform(&self)
    }
    
    @inlinable func transformed(_ transform: (inout Self) -> Void) -> Self {
        var result = self; transform(&result); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func currency(_ formatter: NumberFormatter) -> Character! {
        standard(formatter)
    }
}

//*============================================================================*
// MARK: * Glyphs
//*============================================================================*

/// Multiple UTF-8 encoded ASCII characters.
@usableFromInline protocol Glyphs: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var rawValue: [UInt8] { get }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension Glyphs {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var description: String {
        String(bytes: rawValue, encoding: .utf8)!
    }
}
