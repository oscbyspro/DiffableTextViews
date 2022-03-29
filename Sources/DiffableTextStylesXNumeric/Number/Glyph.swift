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

/// An object representing a UTF-8 encoded ASCII character.
///
/// - The conforming object MUST be a struct (have a bit pattern equal to its rawValue).
///
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
    // MARK: Localization
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
    // MARK: Localization
    //=------------------------------------------------------------------------=
    
    @inlinable func currency(_ formatter: NumberFormatter) -> Character! {
        standard(formatter)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension Glyph {
    
    //=------------------------------------------------------------------------=
    // MARK: ASCII
    //=------------------------------------------------------------------------=
    
    @inlinable var unicode: Unicode.Scalar {
        Unicode.Scalar(rawValue)
    }
    
    @inlinable var character: Character {
        Character(unicode)
    }
    
    @inlinable var description: String {
        unicode.description
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension Glyph {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func transform(_ transform: (inout Self) -> Void) {
        transform(&self)
    }
    
    @inlinable func transformed(_ transform: (inout Self) -> Void) -> Self {
        var result = self; transform(&result); return result
    }
}
