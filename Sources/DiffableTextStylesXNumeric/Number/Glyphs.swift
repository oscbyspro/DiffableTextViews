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

/// An object representing multiple ASCII characters by their UTF8 values.
@usableFromInline protocol Glyphs: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Conversions
    //=------------------------------------------------------------------------=
    
    /// Returns the ASCII representation of this instance as UTF8 encoded bytes.
    @inlinable var rawValue: [UInt8] { get }
}

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension Glyphs {
    
    //=------------------------------------------------------------------------=
    // MARK: Characters / Description
    //=------------------------------------------------------------------------=

    /// Returns the ASCII representation of this instance as a String.
    @inlinable var description: String {
        String(bytes: rawValue, encoding: .utf8)!
    }
}
