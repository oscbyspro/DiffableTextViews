//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

import struct Foundation.Locale

#warning("Rename methods, maybe.")
#warning("Maybe: showcase(Value) -> Snapshot, editable(Value) -> (Value, Snapshot)")
/*
 
 func showcase(value: Value) -> Snapshot
 func editable(value: Value) -> Output<Value>
 func merge(snapshot: Snapshot, input: Input) -> Output<Value>
 
 */

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
    
    /// Interprets the upstream value and downstream mode to produce an output.
    ///
    /// - View is inactive == should only format value.
    /// - View is active == should autocorrect and format value.
    ///
    @inlinable func upstream(value: Value, mode: Mode) -> Output<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    /// Merges the a snapshot and user input to produce an output.
    ///
    /// - Thrown errors result in input cancellation.
    /// - Thrown error descriptions are printed in DEBUG mode.
    ///
    @inlinable func downstream(snapshot: Snapshot, input: Input) throws -> Output<Value>
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
