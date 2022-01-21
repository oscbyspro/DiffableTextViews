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
    /// - The default implementation returns an unmodified instance.
    ///
    @inlinable func locale(_ locale: Locale) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Process
    //=------------------------------------------------------------------------=
    
    /// Processes the value once whenever it is called.
    ///
    /// It is used both downstream and upstream so it can be used to constrain the value.
    ///
    /// - The default implementation returns immediately.
    ///
    @inlinable func process(value: inout Value)
    
    /// Processes the snapshot once whenever it is called.
    ///
    /// Can be used to apply transformation after other snapshot and merge functions.
    ///
    /// - The default implementation returns immediately.
    ///
    @inlinable func process(snapshot: inout Snapshot)
    
    //=------------------------------------------------------------------------=
    // MARK: Parse
    //=------------------------------------------------------------------------=
    
    /// The value represented by the snapshot.
    @inlinable func parse(snapshot: Snapshot) throws -> Value // required (!)
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    /// A snapshot of the value according to the mode.
    @inlinable func snapshot(value: Value, mode: Mode) -> Snapshot // required (!)
    
    //=------------------------------------------------------------------------=
    // MARK: Merge
    //=------------------------------------------------------------------------=
    
    /// Merges the current snapshot with the input.
    ///
    /// - It may also return a value, for performance reasons, if parsed by this method.
    ///
    @inlinable func merge(snapshot: Snapshot, with input: Input) throws -> Output<Value>
}

//=----------------------------------------------------------------------------=
// MARK: DiffableTextStyle - Defaults
//=----------------------------------------------------------------------------=

public extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func locale(_ locale: Locale) -> Self { self }

    //=------------------------------------------------------------------------=
    // MARK: Process
    //=------------------------------------------------------------------------=

    @inlinable func process(value: inout Value) { }

    @inlinable func process(snapshot: inout Snapshot) { }

    //=------------------------------------------------------------------------=
    // MARK: Merge
    //=------------------------------------------------------------------------=
    
    @inlinable func merge(snapshot: Snapshot, with input: Input) throws -> Output<Value> {
        var result = snapshot
        result.replaceSubrange(input.range, with: input.content)
        return Output<Value>(result)
    }
}
