//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

import Foundation

//*============================================================================*
// MARK: * DiffableTextStyle
//*============================================================================*

/// A protocol for styles that are capable of as-you-type formatting and conversion.
public protocol DiffableTextStyle {

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
    // MARK: Upstream
    //=------------------------------------------------------------------------=
    
    /// Transforms the value into formatted text when the view is idle.
    @inlinable func showcase(value: Value) -> String
    
    /// Transforms the value into new commit when the view is active.
    @inlinable func editable(value: Value) -> Commit<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    /// Transforms a proposal into a new commit.
    ///
    /// - Thrown errors result in input cancellation.
    /// - Thrown error descriptions are printed in DEBUG mode.
    ///
    @inlinable func merge(request: Request) throws -> Commit<Value>
}

//=----------------------------------------------------------------------------=
// MARK: DiffableTextStyle - Details
//=----------------------------------------------------------------------------=

public extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func locale(_ locale: Locale) -> Self { self }
}
