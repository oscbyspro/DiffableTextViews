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
        let layout = Layout(Snapshot())
        self.init(layout: layout, selection: layout.startIndex ..< layout.startIndex)
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
// MARK: Update - Snapshot
//=----------------------------------------------------------------------------=

extension State {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
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
// MARK: Update - Selection
//=----------------------------------------------------------------------------=

extension State {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(selection: Range<Layout.Index>, intent: Direction?) {
        //=--------------------------------------=
        // MARK: Reinterpret Intent As Momentum
        //=--------------------------------------=
        let intent = (intent == nil) ? (nil, nil) : (
        Direction(start: self.selection.lowerBound, end: selection.lowerBound),
        Direction(start: self.selection.upperBound, end: selection.upperBound))
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.selection = selection
        self.autocorrect(intent: intent)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations - Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(selection: Range<Position>, intent: Direction?) {
        update(selection: indices(at: selection), intent: intent)
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
        // MARK: Special
        //=--------------------------------------=
        if selection == layout.startIndex ..< layout.endIndex { return }
        //=--------------------------------------=
        // MARK: Upper Bound, Single
        //=--------------------------------------=
        let upperBound = position(start: selection.upperBound, preference: .backwards, intent: intent.upper)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Lower Bound, Double
        //=--------------------------------------=
        if !selection.isEmpty, upperBound != layout.startIndex {
            lowerBound = position(start: selection.lowerBound, preference:  .forwards, intent: intent.lower)
            lowerBound = min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.selection = lowerBound ..< upperBound
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Position
    //=------------------------------------------------------------------------=
    
    @inlinable func position(start: Layout.Index, preference: Direction, intent: Direction?) -> Layout.Index {
        //=--------------------------------------=
        // MARK: Validate
        //=--------------------------------------=
        if layout.look(position: start, direction: preference).map(layout.nonpassthrough) == true { return start }
        //=--------------------------------------=
        // MARK: Direction
        //=--------------------------------------=
        let direction = intent ?? preference
        //=--------------------------------------=
        // MARK: Try
        //=--------------------------------------=
        if let caret = layout.firstIndex(start: start, direction: direction, skip: direction != preference) { return caret }
        //=--------------------------------------=
        // MARK: Try In Reverse Direction
        //=--------------------------------------=
        if let caret = layout.firstIndex(start: start, direction: direction.reversed(), skip: false) { return caret }
        //=--------------------------------------=
        // MARK: Default
        //=--------------------------------------=
        return layout.startIndex
    }
}
