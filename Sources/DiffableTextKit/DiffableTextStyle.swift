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
// MARK: * DiffableTextStyle
//*============================================================================*

/// A protocol for styles that are capable of as-you-type formatting and conversion.
public protocol DiffableTextStyle: Equatable {

    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    associatedtype Value: Equatable
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Updates the locale, if possible.
    ///
    /// - The locale may be overriden by the environment.
    /// - The default implementation returns an unmodified self.
    ///
    @inlinable func locale(_ locale: Locale) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream - Inactive
    //=------------------------------------------------------------------------=
    
    /// Returns formatted text.
    ///
    /// This method is called in response to changes upstream while the view is inactive.
    ///
    @inlinable func format(_ value: Value) -> String
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream - Active
    //=------------------------------------------------------------------------=

    /// Returns a value and a snapshot.
    ///
    /// This method is called in response to changes upstream while the view is active.
    ///
    @inlinable func interpret(_ value: Value) -> Commit<Value>

    //=------------------------------------------------------------------------=
    // MARK: Downstream - Interactive
    //=------------------------------------------------------------------------=
    
    /// Returns a value and a snapshot.
    ///
    /// This method is called in response to user input.
    ///
    /// - Thrown errors result in input cancellation.
    /// - Thrown errors have their descriptions printed in DEBUG mode.
    ///
    @inlinable func merge(_ changes: Changes) throws -> Commit<Value>
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

public extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func locale(_ locale: Locale) -> Self { self }
}
