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

/// A protocol for styles capable of as-you-type formatting.
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
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns formatted text.
    ///
    /// This method is called in response to changes upstream while the view is unfocused.
    ///
    @inlinable func format(_ value: Value) -> String
    
    /// Returns a value and a snapshot.
    ///
    /// This method is called in response to changes upstream while the view is focused.
    ///
    @inlinable func interpret(_ value: Value) -> Commit<Value>
    
    /// Returns a value and a snapshot.
    ///
    /// This method is called in response to user input.
    ///
    /// - Thrown errors result in input cancellation.
    /// - Thrown errors have their descriptions printed in DEBUG mode.
    ///
    @inlinable func merge(_ changes: Changes) throws -> Commit<Value>
    
    //*========================================================================*
    // MARK: * UIKit
    //*========================================================================*
    
    #if canImport(UIKit)

    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    @inlinable static func onSetup(_ diffableTextField: ProxyTextField)
    
    #endif
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

public extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func locale(_ locale: Locale) -> Self { self }
    
    //*========================================================================*
    // MARK: * UIKit
    //*========================================================================*
    
    #if canImport(UIKit)

    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    @inlinable static func onSetup(_ diffableTextField: ProxyTextField) { }
    
    #endif
}
