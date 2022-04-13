//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Field
//*============================================================================*

/// A model describing a snapshot's snapshot and a selection in it.
///
/// - Autocorrects selection on snapshot changes.
/// - Autocorrects selection on selection changes.
///
@usableFromInline struct Field {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var snapshot: Snapshot
    @usableFromInline var selection: Range<Index>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ snapshot: Snapshot = Snapshot()) {
        self.snapshot = snapshot; self.selection = .empty(snapshot.endIndex)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension Field {

    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(snapshot: Snapshot) {
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = Mismatches.backwards(to: snapshot,
        from: self.snapshot[selection.upperBound...]).next
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !selection.isEmpty {
            lowerBound = Mismatches.forwards(to: snapshot,
            from: self.snapshot[..<selection.lowerBound]).next
            lowerBound = Swift.min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.snapshot = snapshot
        self.update(selection: .unchecked((lowerBound, upperBound)))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension Field {
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update<T>(selection: Range<T.Position>, momentum: Bool) where T: Offset {
        //=--------------------------------------=
        // MARK: Values
        //=--------------------------------------=
        let selection = indices(at: selection)
        let momentum = momentum ? Directions(from: self.selection, to: selection) : .none
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.update(selection: selection, momentum: momentum)
    }
    
    @inlinable mutating func update(selection: Range<Index>, momentum: Directions = .none) {
        //=--------------------------------------=
        // MARK: Accept Max Selection
        //=--------------------------------------=
        if selection == snapshot.range {
            self.selection = selection
            return
        }
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = snapshot.caret(from: selection.upperBound,
        /**/towards: momentum.upperBound, preferring: .backwards)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !selection.isEmpty {
            lowerBound = snapshot.caret(from: selection.lowerBound,
            towards: momentum.lowerBound, preferring:  .forwards)
            lowerBound = Swift.min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.selection = .unchecked((lowerBound, upperBound))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension Field {
    
    //=------------------------------------------------------------------------=
    // MARK: Ranges
    //=------------------------------------------------------------------------=
    
    @inlinable func indices<T>(at positions: Range<T.Position>) -> Range<Index> where T: Offset {
        range(at: positions, map: snapshot.index(at:))
    }

    @inlinable func positions<T>(at indices: Range<Index>) -> Range<T.Position> where T: Offset {
        range(at: indices, map: snapshot.position(at:))
    }
    
    @inlinable func range<Input, Output>(at range: Range<Input>,
    map bound: (Input) -> Output) -> Range<Output> {
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = bound(range.upperBound)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !range.isEmpty {
            lowerBound = bound(range.lowerBound)
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return .unchecked((lowerBound, upperBound))
    }
}
