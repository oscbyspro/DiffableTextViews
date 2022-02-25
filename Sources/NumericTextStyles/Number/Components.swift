//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Components
//*============================================================================*

/// An object representing multiple ASCII characters by their UInt8 unicode values.
@usableFromInline protocol Components: CustomStringConvertible, TextOutputStreamable {
    
    //=------------------------------------------------------------------------=
    // MARK: Conversions
    //=------------------------------------------------------------------------=
    
    /// Writes the ASCII representation of this instance to the target.
    @inlinable func write<T>(to target: inout T) where T: TextOutputStream
}

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension Components {
    
    //=------------------------------------------------------------------------=
    // MARK: Characters / Description
    //=------------------------------------------------------------------------=
    
    /// Returns the ASCII representation of this instance.
    @inlinable func characters() -> String {
        description
    }
    
    /// Returns the ASCII representation of this instance.
    @inlinable var description: String {
        var characters = String(); write(to: &characters); return characters
    }
}
