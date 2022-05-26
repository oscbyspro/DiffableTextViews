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
    
    @inlinable var reader: Reader { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    /// Autocorrects a snapshot in ways specific to this instance.
    ///
    /// - It may mark currency expressions as virtual, for example.
    ///
    @inlinable func autocorrect(_ snapshot: inout Snapshot)
    
    //=------------------------------------------------------------------------=
    // MARK: Preferences
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
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumberTextScheme {
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ snapshot: inout Snapshot) { }
    
    //=------------------------------------------------------------------------=
    // MARK: Preferences
    //=------------------------------------------------------------------------=
    
    @inlinable func preferred<T>(_ value: T.Type) -> NumberTextBounds<T> {
        NumberTextBounds()
    }
    
    @inlinable func preferred<T>(_ value: T.Type) -> NumberTextPrecision<T> {
        NumberTextPrecision()
    }
}
