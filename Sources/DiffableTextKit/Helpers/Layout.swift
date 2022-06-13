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
    
    @inlinable init(_ snapshot: Snapshot = Snapshot()) {
        self.snapshot = snapshot; self.selection = Carets(snapshot.endIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable func selection<T>(as type: Position<T>.Type =
    Position<T>.self) -> Carets<T.Position> where T: Encoding {
        positions(at: selection)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable func indices<T>(at positions: Carets<T.Position>) -> Carets<Index> where T: Encoding {
        positions.map(caret: snapshot.index(at:))
    }

    @inlinable func positions<T>(at indices: Carets<Index>) -> Carets<T.Position> where T: Encoding {
        indices.map(caret: snapshot.position(at:))
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func merge(snapshot: Snapshot) {
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        let selection = selection.map(
        lower: { Mismatches .forwards(from: self.snapshot[..<$0], to: snapshot).next },
        upper: { Mismatches.backwards(from: self.snapshot[$0...], to: snapshot).next })
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.snapshot = snapshot; self.merge(selection: selection)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func merge<T>(selection: Carets<T.Position>, momentums: Bool) where T: Encoding {
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        let selection = indices(at: selection)
        let momentums = momentums ? Directions(from: self.selection, to: selection) : .none
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.merge(selection: selection, momentums: momentums)
    }
    
    @inlinable mutating func merge(selection: Carets<Index>, momentums: Directions = .none) {
        switch selection {
        //=--------------------------------------=
        // Accept Max Selection
        //=--------------------------------------=
        case .unchecked((snapshot.startIndex, snapshot.endIndex)): self.selection = selection
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        default: self.selection = selection.map(
        lower: { snapshot.caret(from: $0, towards: momentums.lower, preferring:  .forwards) },
        upper: { snapshot.caret(from: $0, towards: momentums.upper, preferring: .backwards) })
        }
    }
}
