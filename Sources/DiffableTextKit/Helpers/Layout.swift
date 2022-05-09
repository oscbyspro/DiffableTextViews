//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: Declaration
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
    
    @inlinable init(_ snapshot: Snapshot = Snapshot()) {
        self.snapshot = snapshot; self.selection = Carets(snapshot.endIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable func indices<T>(at positions: Carets<T.Position>) -> Carets<Index> where T: Offset {
        positions.map(caret: snapshot.index(at:))
    }

    @inlinable func positions<T>(at indices: Carets<Index>) -> Carets<T.Position> where T: Offset {
        indices.map(caret: snapshot.position(at:))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Transformations
//=----------------------------------------------------------------------------=

extension Layout {

    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(snapshot: Snapshot) {
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        let selection = selection.map(
        lower: { Mismatches .forwards(from: self.snapshot[..<$0], to: snapshot).next },
        upper: { Mismatches.backwards(from: self.snapshot[$0...], to: snapshot).next })
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.snapshot = snapshot; self.update(selection: selection)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=

    @inlinable mutating func update<T>(selection: Carets<T.Position>, momentum: Bool) where T: Offset {
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        let selection = indices(at: selection) // translate positions to indices
        let momentum = momentum ? Directions(from: self.selection, to: selection) : .none
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.update(selection: selection, momentum: momentum)
    }
    
    @inlinable mutating func update(selection: Carets<Index>, momentum: Directions = .none) {
        switch selection {
        //=--------------------------------------=
        // Accept Max Value
        //=--------------------------------------=
        case .unchecked((snapshot.startIndex, snapshot.endIndex)): self.selection = selection
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        default: self.selection = selection.map(
        lower: { snapshot.caret(from: $0, towards: momentum.lowerBound, preferring:  .forwards) },
        upper: { snapshot.caret(from: $0, towards: momentum.upperBound, preferring: .backwards) })
        }
    }
}
