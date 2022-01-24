//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

import struct Foundation.Locale

#warning("Rename methods, maybe.")

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
    /// - The locale may be provided by the environment.
    /// - The default implementation returns an unmodified self.
    ///
    @inlinable func locale(_ locale: Locale) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream
    //=------------------------------------------------------------------------=
    
    #warning("Throws or not, unsure.")
    /// Interprets the upstream value and downstream mode to produce an output.
    @inlinable func upstream(value: Value, mode: Mode) -> Output<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    #warning("Throws or not, unsure.")
    /// Merges the downstream snapshot and downstream input to produce an output.
    @inlinable func downstream(snapshot: Snapshot, input: Input) -> Output<Value>
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
