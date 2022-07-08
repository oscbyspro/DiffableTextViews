//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Layout
//*============================================================================*

/// A model describing a snapshot and a selection in it.
///
/// - Autocorrects selection when the snapshot changes.
/// - Autocorrects selection when the selection changes.
///
@usableFromInline struct Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var snapshot:  Snapshot
    @usableFromInline var selection: Selection<Index>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(  _ snapshot: Snapshot) {
        self.snapshot = snapshot; self.selection = .initial(snapshot) // O(n)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Use this on changes to text.
    @inlinable mutating func merge(snapshot: Snapshot) {
        let selection = selection.map(
        lower: { Mismatches .forwards(from: self.snapshot[..<$0.position], to: snapshot).next },
        upper: { Mismatches.backwards(from: self.snapshot[$0.position...], to: snapshot).next })
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.snapshot = snapshot; self.merge(selection: selection)
    }
    
    /// Use this on changes to selection.
    @inlinable mutating func merge(selection: Selection<Index>, momentums: Bool = false) {
        //=--------------------------------------=
        // Accept Max Selection
        //=--------------------------------------=
        if  selection == .max(snapshot) {
            self.selection = selection; return
        }
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        var lower = Detached(selection.lower.position, affinity: selection.lower.affinity)
        var upper = Detached(selection.upper.position, affinity: selection.upper.affinity)

        if  momentums {
            lower.momentum = Direction(from: self.selection.lower, to: selection.lower)
            upper.momentum = Direction(from: self.selection.upper, to: selection.upper)
        }
        
        self.selection = snapshot.resolve(Selection(unchecked: (lower, upper)))
    }
}
