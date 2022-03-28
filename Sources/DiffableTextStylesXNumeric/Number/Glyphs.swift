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

/// An object representing multiple ASCII characters by their UInt8 unicode values.
///
/// - The conforming object MUST be a struct.
/// - The conforming object SHOULD implement a single private init method.
///
@usableFromInline protocol Glyphs: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Conversions
    //=------------------------------------------------------------------------=
        
    @inlinable var bytes: [UInt8] { get }
}

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension Glyphs {
    
    //=------------------------------------------------------------------------=
    // MARK: Characters / Description
    //=------------------------------------------------------------------------=

    /// Returns the ASCII representation of this instance.
    @inlinable var description: String {
        String(bytes: bytes, encoding: .utf8)!
    }
}
