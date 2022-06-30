//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//*============================================================================*
// MARK: * Scheme
//*============================================================================*

public protocol NumberTextScheme {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var reader: NumberTextReader { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// The bounds preferred by this instance.
    ///
    /// - The return value of this method MUST NOT depend on locale (v3.1.0).
    ///
    @inlinable func preferred<T>(_ value: T.Type) -> NumberTextBounds<T>
    
    /// The precision preferred by this instance.
    ///
    /// - The return value of this method MUST NOT depend on locale (v3.1.0).
    ///
    @inlinable func preferred<T>(_ value: T.Type) -> NumberTextPrecision<T>
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func snapshot(_ characters: String)  -> Snapshot
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumberTextScheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable func preferred<T>(_ value: T.Type) -> NumberTextBounds<T> {
        NumberTextBounds()
    }
    
    @inlinable func preferred<T>(_ value: T.Type) -> NumberTextPrecision<T> {
        NumberTextPrecision()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        Snapshot(characters, as: reader.attributes.map)
    }
}
