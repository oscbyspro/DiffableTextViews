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

/// An object representing an ASCII character by its UInt8 unicode scalar value.
@usableFromInline protocol Component: RawRepresentable,
Hashable, CaseIterable, TextOutputStreamable where RawValue == UInt8 {
    
    //=------------------------------------------------------------------------=
    // MARK: Localization
    //=------------------------------------------------------------------------=
        
    @inlinable func standard(_ formatter: NumberFormatter) -> Character!

    @inlinable func currency(_ formatter: NumberFormatter) -> Character!
}

//=----------------------------------------------------------------------------=
// MARK: + Localization
//=----------------------------------------------------------------------------=

extension Component {
    
    //=------------------------------------------------------------------------=
    // MARK: Defaults
    //=------------------------------------------------------------------------=
    
    @inlinable func currency(_ formatter: NumberFormatter) -> Character! {
        standard(formatter)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unicodeable
//=----------------------------------------------------------------------------=

extension Component {
    
    //=------------------------------------------------------------------------=
    // MARK: Unicode
    //=------------------------------------------------------------------------=
    
    @inlinable var unicode: Unicode.Scalar {
        Unicode.Scalar(rawValue)
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Character
    //=------------------------------------------------------------------------=
    
    @inlinable var character: Character {
        Character(unicode)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Write
    //=------------------------------------------------------------------------=
    
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
