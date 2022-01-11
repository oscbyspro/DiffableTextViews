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
    // MARK: Merge
    //=------------------------------------------------------------------------=
    
    /// Merges the current snapshot with the input snapshot proposed by the user,
    ///
    /// - Parameters:
    ///     - snapshot: current snapshot
    ///     - content: user input with empty attributes
    ///     - range: indices in snapshot that content is proposed to change
    ///
    @inlinable func merge(snapshot: Snapshot, with input: Input) throws -> Snapshot
        
    //=------------------------------------------------------------------------=
    // MARK: Parse
    //=------------------------------------------------------------------------=
    
    /// Value represented by the snapshot.
    @inlinable func parse(snapshot: Snapshot) throws -> Value // required (!)

    //=------------------------------------------------------------------------=
    // MARK: Process
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
    
    @inlinable func merge(snapshot: Snapshot, with input: Input) throws -> Snapshot {
        var proposal = snapshot
        proposal.replaceSubrange(input.range, with: input.content)
        return proposal
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Process
    //=------------------------------------------------------------------------=

    @inlinable func process(value: inout Value) { }

    @inlinable func process(snapshot: inout Snapshot) { }
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

//*============================================================================*
// MARK: * DiffableTextStyle x UIKit
//*============================================================================*

#if canImport(UIKit)

import UIKit

public protocol UIKitDiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable var keyboard: UIKeyboardType { get }
}

//=----------------------------------------------------------------------------=
// MARK: DiffableTextStyle x UIKit - Implementation
//=----------------------------------------------------------------------------=

extension UIKitDiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable var keyboard: UIKeyboardType {
        .default
    }
}

#endif
