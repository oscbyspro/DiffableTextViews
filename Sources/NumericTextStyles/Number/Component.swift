//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation
import Support

//*============================================================================*
// MARK: * Component
//*============================================================================*

/// An object representing an ASCII character by its UInt8 unicode value.
@usableFromInline protocol Component: RawRepresentable, Hashable, CaseIterable,
TextOutputStreamable, CustomStringConvertible where RawValue == UInt8 {
    
    //=------------------------------------------------------------------------=
    // MARK: Localization
    //=------------------------------------------------------------------------=
        
    @inlinable func standard(_ formatter: NumberFormatter) -> Character!

    @inlinable func currency(_ formatter: NumberFormatter) -> Character!
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension Component {
    
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

extension Component {
    
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

extension Component {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func transform(_ transform: (inout Self) -> Void) -> Self {
        var result = self; transform(&result); return result
    }
}
