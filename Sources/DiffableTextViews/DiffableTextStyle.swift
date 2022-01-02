//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

//*============================================================================*
// MARK: * DiffableTextStyle
//*============================================================================*

public protocol DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    associatedtype Value: Equatable
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    /// Snapshot for when the view is idle.
    @inlinable func snapshot(showcase value: Value) -> Snapshot

    /// Snapshot for when the view is in editing mode.
    @inlinable func snapshot(editable value: Value) -> Snapshot // required (!)
    
    //=------------------------------------------------------------------------=
    // MARK: Parse
    //=------------------------------------------------------------------------=
    
    /// Value represented by the snapshot or nil if the snapshot is invalid.
    @inlinable func parse(snapshot: Snapshot) throws -> Value // required (!)

    //=------------------------------------------------------------------------=
    // MARK: Merge
    //=------------------------------------------------------------------------=
    
    /// Merges the current snapshot with the input snapshot proposed by the user,
    ///
    /// - Parameters:
    ///     - snapshot: current snapshot
    ///     - content: user input with empty attributes
    ///     - range: indices in snapshot that content is proposed to change
    ///
    @inlinable func merge(snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) throws -> Snapshot
    
    //=------------------------------------------------------------------------=
    // MARK: Processs
    //=------------------------------------------------------------------------=
    
    #warning("Consider: throws.")
    /// Processes the value once whenever it is called. It is used both downstream and upstream so it can be used to constrain the value.
    @inlinable func process(value: inout Value)

    #warning("Consider: throws.")
    /// Processes the snapshot once whenever it is called. Can be used to apply transformation after other snapshot and merge functions.
    @inlinable func process(snapshot: inout Snapshot)
}

//=----------------------------------------------------------------------------=
// MARK: DiffableTextStyle - Implementation
//=----------------------------------------------------------------------------=

public extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=

    @inlinable func snapshot(showcase value: Value) -> Snapshot {
        snapshot(editable: value)
    }

    //=------------------------------------------------------------------------=
    // MARK: Merge
    //=------------------------------------------------------------------------=
    
    @inlinable func merge(snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot? {
        var result = snapshot; result.replaceSubrange(range, with: content); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Process
    //=------------------------------------------------------------------------=

    @inlinable func process(value: inout Value) {
        // default implementation does nothing
    }

    @inlinable func process(snapshot: inout Snapshot) {
        // default implementation does nothing
    }
}

//=----------------------------------------------------------------------------=
// MARK: DiffableTextStyle - Utilities
//=----------------------------------------------------------------------------=

extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    @inlinable func snapshot(value: Value, mode: Mode) -> Snapshot {
        switch mode {
        case .showcase: return snapshot(showcase: value)
        case .editable: return snapshot(editable: value)
        }
    }
}
