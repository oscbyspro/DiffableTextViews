//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Glyphs
//*============================================================================*

/// An object representing multiple UTF-8 encoded ASCII characters.
@usableFromInline protocol Glyphs: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Conversions
    //=------------------------------------------------------------------------=
    
    @inlinable var rawValue: [UInt8] { get }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension Glyphs {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=

    @inlinable var description: String {
        String(bytes: rawValue, encoding: .utf8)!
    }
}
