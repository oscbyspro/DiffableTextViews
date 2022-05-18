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
// MARK: Declaration
//*============================================================================*

/// A protocol for styles capable of as-you-type formatting.
public protocol DiffableTextStyle: Equatable {

    //=------------------------------------------------------------------------=
    // MARK: Types
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
    
    /// Returns a value and a snapshot describing it.
    ///
    /// This method is called in response to changes upstream while the view is focused.
    ///
    @inlinable func interpret(_ value: Value) -> Commit<Value>
    
    /// Returns a value and a snapshot describing it.
    ///
    /// This method is called in response to user input.
    ///
    /// - Thrown errors result in input cancellation.
    /// - Thrown errors have their descriptions printed in DEBUG mode.
    ///
    @inlinable func resolve(_ proposal: Proposal) throws -> Commit<Value>
}

//=----------------------------------------------------------------------------=
// MARK: Details
//=----------------------------------------------------------------------------=

public extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func locale(_ locale: Locale) -> Self { self }
}

//*============================================================================*
// MARK: Declaration
//*============================================================================*

public protocol DiffableTextStyleWrapper: DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Style
    //=------------------------------------------------------------------------=
    
    associatedtype Style: DiffableTextStyle

    @inlinable var style: Style { get set }
}

//=----------------------------------------------------------------------------=
// MARK: Details
//=----------------------------------------------------------------------------=

extension DiffableTextStyleWrapper {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func locale(_ locale: Locale) -> Self {
        var result = self
        result.style = result.style.locale(locale)
        return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func format(_ value: Value) -> String
    where Value == Style.Value {
        style.format(value)
    }

    @inlinable @inline(__always)
    public func interpret(_ value: Value) -> Commit<Value>
    where Value == Style.Value {
        style.interpret(value)
    }

    @inlinable @inline(__always)
    public func resolve(_ proposal: Proposal) throws -> Commit<Value>
    where Value == Style.Value {
        try style.resolve(proposal)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.style == rhs.style
    }
}
