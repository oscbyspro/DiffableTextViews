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
    
    @usableFromInline var snapshot: Snapshot
    @usableFromInline var selection: Carets<Index>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ snapshot: Snapshot) {
        self.snapshot = snapshot; self.selection = Carets(snapshot.defaultIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Use this on changes to text.
    @inlinable mutating func merge(snapshot: Snapshot) {
        let selection = selection.map(
        lower: { Mismatches .forwards(from: self.snapshot[..<$0], to: snapshot).next },
        upper: { Mismatches.backwards(from: self.snapshot[$0...], to: snapshot).next })
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.snapshot = snapshot; self.merge(selection: selection, momentums: false)
    }
    
    /// Use this on changes to selection.
    @inlinable mutating func merge(selection: Carets<some Position>, momentums: Bool) {
        let  selection = Carets(snapshot.indices(at: selection.range))
        let  momentums = momentums ? Momentums(from: self.selection, to: selection) : .none
        self.selection = selection
        //=--------------------------------------=
        // Accept Max Or Autocorrect
        //=--------------------------------------=
        if selection == Carets(unchecked: (snapshot.startIndex, snapshot.endIndex)) { return }
        self.autocorrect(momentums: momentums)
    }
    
    /// Autocorrect selection according to momentums and attributes.
    @inlinable mutating func autocorrect(momentums: Momentums = .none) {
        self.selection = selection.map(
        lower: { snapshot.caret(from: $0, towards: momentums.lower, preferring:  .forwards) },
        upper: { snapshot.caret(from: $0, towards: momentums.upper, preferring: .backwards) })
    }
}
