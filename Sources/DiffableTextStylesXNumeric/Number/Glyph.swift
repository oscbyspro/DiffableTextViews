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
@usableFromInline protocol Glyph: RawRepresentable, Hashable, CaseIterable,
CustomStringConvertible, TextOutputStreamable where RawValue == UInt8 {
    
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
    // MARK: Unicodeable
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
    
    /// Writes the ASCII representation of this instance to the target.
    @inlinable func write<T>(to target: inout T) where T: TextOutputStream {
        unicode.write(to: &target)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension Glyph {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func transform(_ transform: (inout Self) -> Void) -> Self {
        var result = self; transform(&result); return result
    }
}
