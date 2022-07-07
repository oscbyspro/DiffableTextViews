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
    @usableFromInline typealias Selection = DiffableTextKit.Selection<Index>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var snapshot:  Snapshot
    @usableFromInline var selection: Selection
    
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
    @inlinable mutating func merge(selection: Selection, momentums: Bool = false) {
        //=--------------------------------------=
        // Accept Max Selection
        //=--------------------------------------=
        if  selection == .max(snapshot) {
            self.selection = selection; return
        }
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        let momentums = !momentums ? Momentums() :
        Momentums(from: self.selection, to: selection)
        
        let  selection = selection.detached(momentums)
        self.selection = snapshot.selection(selection)
    }
}
