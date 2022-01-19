//
//  State.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

//*============================================================================*
// MARK: * State
//*============================================================================*

@usableFromInline struct State<Scheme: DiffableTextViews.Scheme> {
    @usableFromInline typealias Layout = DiffableTextViews.Layout<Scheme>
    @usableFromInline typealias Position = DiffableTextViews.Position<Scheme>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var layout: Layout
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
    
    @inlinable var snapshot: Snapshot {
        layout.snapshot
    }
    
    @inlinable var positions: Range<Position> {
        selection.lowerBound.position ..< selection.upperBound.position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func indices(at destination: Range<Position>) -> Range<Layout.Index> {
        layout.indices(start: selection, destination: destination)
    }
}

//=----------------------------------------------------------------------------=
// MARK: State - Update
//=----------------------------------------------------------------------------=

extension State {

    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(snapshot: Snapshot) {
        let layout = Layout(snapshot)
        //=--------------------------------------=
        // MARK: Selection
        //=--------------------------------------=
        let upperBound = Changes  .end(past: self.layout[self.selection.upperBound...], next: layout).next
        var lowerBound = upperBound
        
        if !self.selection.isEmpty {
            lowerBound = Changes.start(past: self.layout[..<self.selection.lowerBound], next: layout).next
            lowerBound = min(lowerBound, upperBound)
        }

        let selection = lowerBound ..< upperBound
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.layout = layout
        self.selection = selection
        self.autocorrect(intent: (nil, nil))
    }
}

//=----------------------------------------------------------------------------=
// MARK: State - Update
//=----------------------------------------------------------------------------=

extension State {
    
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
        Direction(start: self.selection.lowerBound, end: selection.lowerBound),
        Direction(start: self.selection.upperBound, end: selection.upperBound))
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.selection = selection
        self.autocorrect(intent: intent)
    }
}

//=----------------------------------------------------------------------------=
// MARK: State - Autocorrect
//=----------------------------------------------------------------------------=

extension State {
        
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func autocorrect(intent: (lower: Direction?, upper: Direction?)) {
        //=--------------------------------------=
        // MARK: Exceptions
        //=--------------------------------------=
        if selection == layout.range { return }
        //=--------------------------------------=
        // MARK: Upper Bound, Single
        //=--------------------------------------=
        let upperBound = layout.preferredIndex(start: selection.upperBound, preference: .backwards, intent: intent.upper)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Lower Bound, Double
        //=--------------------------------------=
        if !selection.isEmpty, upperBound != layout.startIndex {
            lowerBound = layout.preferredIndex(start: selection.lowerBound, preference:  .forwards, intent: intent.lower)
            lowerBound = min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.selection = lowerBound ..< upperBound
    }
}
