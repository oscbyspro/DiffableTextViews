//
//  Selection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-27.
//

import Foundation

//*============================================================================*
// MARK: * Selection
//*============================================================================*

/// A representation of the view.
///
/// It controls how the selection is updated when various parameters change.
///
@usableFromInline struct Selection<Scheme: DiffableTextViews.Scheme> {
    @usableFromInline typealias Layout = DiffableTextViews.Layout<Scheme>
    @usableFromInline typealias Position = DiffableTextViews.Position<Scheme>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var range: Range<Layout.Index>
    @usableFromInline private(set) var layout: Layout

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.layout = Layout()
        self.range = layout.range
    }
    
    @inlinable init(layout: Layout, range: Range<Layout.Index>) {
        self.range = range
        self.layout = layout
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable var positions: Range<Position> {
        range.lowerBound.position ..< range.upperBound.position
    }
}

//=----------------------------------------------------------------------------=
// MARK: Selection - Indices
//=----------------------------------------------------------------------------=

extension Selection {

    //=------------------------------------------------------------------------=
    // MARK: Destination
    //=------------------------------------------------------------------------=
    
    @inlinable func indices(at destination: Range<Position>) -> Range<Layout.Index> {
        layout.indices(start: range, destination: destination)
    }
    
    @inlinable func indices(at destination: NSRange) -> Range<Layout.Index> {
        indices(at: Position(destination.lowerBound) ..< Position(destination.upperBound))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Selection - Update
//=----------------------------------------------------------------------------=

extension Selection {

    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(snapshot: Snapshot) {
        let layout = Layout(snapshot)
        //=--------------------------------------=
        // MARK: Selection - Single
        //=--------------------------------------=
        let upperBound = Mismatches.suffix(past: self.layout[range.upperBound...], next: layout).next
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Selection - Double
        //=--------------------------------------=
        if !self.range.isEmpty {
            lowerBound = Mismatches.prefix(past: self.layout[..<range.lowerBound], next: layout).next
            lowerBound = min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.layout = layout
        self.range = lowerBound ..< upperBound
        self.autocorrect(intent: (nil, nil))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Selection - Update
//=----------------------------------------------------------------------------=

extension Selection {
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(selection: Range<Position>, momentum: Bool) {
        //=--------------------------------------=
        // MARK: Parse Position As Index
        //=--------------------------------------=
        let selection = indices(at: selection)
        //=--------------------------------------=
        // MARK: Parse Momentum As Intent
        //=--------------------------------------=
        let intent = !momentum ? (nil, nil) : (
        Direction(start: self.range.lowerBound, end: selection.lowerBound),
        Direction(start: self.range.upperBound, end: selection.upperBound))
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.range = selection
        self.autocorrect(intent: intent)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Selection - Autocorrect
//=----------------------------------------------------------------------------=

extension Selection {
        
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func autocorrect(intent: (lower: Direction?, upper: Direction?)) {
        //=--------------------------------------=
        // MARK: Exceptions
        //=--------------------------------------=
        if range == layout.range { return }
        //=--------------------------------------=
        // MARK: Selection - Single
        //=--------------------------------------=
        let upperBound = layout.preferredIndex(start: range.upperBound, preference: .backwards, intent: intent.upper)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Selection - Double
        //=--------------------------------------=
        if !range.isEmpty, upperBound != layout.startIndex {
            lowerBound = layout.preferredIndex(start: range.lowerBound, preference:  .forwards, intent: intent.lower)
            lowerBound = min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.range = lowerBound ..< upperBound
    }
}
