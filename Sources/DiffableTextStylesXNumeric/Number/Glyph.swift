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

/// An object representing an ASCII character by its UInt8 unicode value.
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
    // MARK: ASCII
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func write(into bytes: inout [UInt8]) {
        bytes.append(rawValue)
    }
    
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
    
    /// Returns the ASCII representation of this instance.
    @inlinable var unicode: Unicode.Scalar {
        Unicode.Scalar(rawValue)
    }
    
    /// Returns the ASCII representation of this instance.
    @inlinable var character: Character {
        Character(unicode)
    }
    
    /// Returns the ASCII representation of this instance.
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
