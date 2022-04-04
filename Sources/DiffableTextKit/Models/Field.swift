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

/// A model describing a snapshot's layout and a selection in it.
public struct Field<Scheme: DiffableTextKit.Scheme> {
    public typealias Layout = DiffableTextKit.Layout<Scheme>
    public typealias Position = DiffableTextKit.Position<Scheme>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var layout: Layout
    @usableFromInline var selection: Range<Layout.Index>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.layout = Layout()
        self.selection = layout.range
    }
    
    @inlinable init(layout: Layout, selection: Range<Layout.Index>) {
        self.layout = layout
        self.selection = selection
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable public var snapshot: Snapshot {
        layout.snapshot
    }
    
    @inlinable public var characters: String {
        layout.snapshot.characters
    }
    
    @inlinable public var positions: Range<Position> {
        selection.lowerBound.position ..< selection.upperBound.position
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Accessors
//=----------------------------------------------------------------------------=

extension Field {

    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable public func indices(at destination: Range<Position>) -> Range<Layout.Index> {
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = layout.index(at: destination.upperBound, from: selection.upperBound)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !destination.isEmpty {
            lowerBound = layout.index(at: destination.lowerBound, from: selection.lowerBound)
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return lowerBound ..< upperBound
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension Field {
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(selection: Range<Position>, momentum: Bool) {
        let selection = indices(at: selection)
        //=--------------------------------------=
        // MARK: Parse Boolean As Momentum
        //=--------------------------------------=
        let momentum = momentum ? Momentum(self.selection, to: selection) : .none
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.update(selection: selection, momentum: momentum)
    }
    
    @inlinable mutating func update(selection: Range<Layout.Index>, momentum: Momentum = .none) {
        //=--------------------------------------=
        // MARK: Accept Max Selection
        //=--------------------------------------=
        if selection == layout.range {
            self.selection = selection; return
        }
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = layout.caret(from: selection.upperBound,
            towards: momentum.upperBound, preferring: .backwards)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !selection.isEmpty, upperBound != layout.startIndex {
            lowerBound = layout.caret(from: selection.lowerBound,
            towards: momentum.lowerBound, preferring:  .forwards)
            lowerBound = Swift.min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.selection = lowerBound ..< upperBound
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
        let layout = Layout(snapshot)
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = Mismatches.suffix(next: layout,
        prev: self.layout[selection.upperBound...]).next
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !selection.isEmpty {
            lowerBound = Mismatches.prefix(next: layout,
            prev: self.layout[..<selection.lowerBound]).next
            lowerBound = Swift.min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.layout = layout
        self.update(selection: lowerBound ..< upperBound)
    }
}
