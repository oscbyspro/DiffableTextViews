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
// MARK: * Unit
//*============================================================================*

/// An object representing an ASCII character by its UInt8 unicode scalar value.
@usableFromInline protocol Unit:
RawRepresentable, Hashable, CaseIterable, TextOutputStreamable where RawValue == UInt8 {
    
    //=------------------------------------------------------------------------=
    // MARK: Localization
    //=------------------------------------------------------------------------=
        
    @inlinable func standard(_ formatter: NumberFormatter) -> Character?

    @inlinable func currency(_ formatter: NumberFormatter) -> Character?
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension Unit {
    
    //=------------------------------------------------------------------------=
    // MARK: Localization - Default
    //=------------------------------------------------------------------------=
    
    @inlinable func standard(_ formatter: NumberFormatter) throws -> Character {
        try standard(formatter) ?! nonlocalizable
    }
    
    @inlinable func currency(_ formatter: NumberFormatter) throws -> Character {
        try currency(formatter) ?! nonlocalizable
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Localization - Errors
    //=------------------------------------------------------------------------=
    
    @inlinable var nonlocalizable: Info {
        Info(["unable to localize", .mark(self)])
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unicodeable
//=----------------------------------------------------------------------------=

extension Unit {
    
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
    
    @inlinable func write<T: TextOutputStream>(to target: inout T) {
        unicode.write(to: &target)
    }
}
