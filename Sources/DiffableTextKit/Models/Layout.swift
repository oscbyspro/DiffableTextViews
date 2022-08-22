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
/// - Autocorrects selection when the snapshot  changes.
/// - Autocorrects selection when the selection changes.
///
@usableFromInline struct Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var snapshot: Snapshot
    @usableFromInline private(set) var preference: Selection<Index>?
    @usableFromInline var selection: Selection<Index>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ snapshot: Snapshot, preference: Selection<Index>?) {
        self.init(deferring: (snapshot, preference)); self.autocorrect()
    }
    
    /// Use this method to defer autocorrection.
    @inlinable init(deferring:(snapshot: Snapshot, preference: Selection<Index>?)) {
        self.snapshot = deferring.snapshot
        self.preference = deferring.preference
        self.selection = Selection(snapshot.endIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Use this method on changes to text.
    @inlinable mutating func merge(snapshot: Snapshot, preference: Selection<Index>?) {
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        let selection = preference ?? selection.map(
        lower: { Mismatches .forwards(from: self.snapshot[..<$0], to: snapshot).next },
        upper: { Mismatches.backwards(from: self.snapshot[$0...], to: snapshot).next })
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.snapshot = snapshot
        self.preference = preference
        self.merge(selection: selection)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Use this method to resolve selection.
    @inlinable mutating func autocorrect() {
        self.merge(selection: self.selection)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Use this method on changes to selection.
    @inlinable mutating func merge(selection: Selection<Index>, resolve: Resolve = []) {
        //=--------------------------------------=
        // Accept Max Selection
        //=--------------------------------------=
        if  resolve.contains(.max), selection == .max(snapshot) {
            self.selection = selection; return
        }
        //=--------------------------------------=
        // Manual
        //=--------------------------------------=
        if  let preference {
            self.selection = preference; return
        }
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        var carets = selection.carets().detached()
        
        if  resolve.contains(.momentums) {
            carets.lower.momentum = Direction(from: self.selection.lower, to: selection.lower)
            carets.upper.momentum = Direction(from: self.selection.upper, to: selection.upper)
        }
        
        self.selection = Selection(unchecked: carets).map(snapshot.resolve(_:))
    }
}
