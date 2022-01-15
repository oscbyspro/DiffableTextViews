//
//  State.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

import Quick

//*============================================================================*
// MARK: * State
//*============================================================================*

@usableFromInline struct State<Scheme: DiffableTextViews.Scheme>: Transformable {
    @usableFromInline typealias Positions = DiffableTextViews.Positions<Scheme>
    @usableFromInline typealias Position = DiffableTextViews.Position<Scheme>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var positions: Positions
    @usableFromInline var selection: Range<Positions.Index>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        let positions = Positions(Snapshot())
        self.init(positions: positions, selection: positions.startIndex ..< positions.startIndex)
    }
    
    @inlinable init(positions: Positions, selection: Range<Positions.Index>) {
        self.positions = positions
        self.selection = selection
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var snapshot: Snapshot {
        positions.snapshot
    }
    
    @inlinable var offsets: Range<Position> {
        selection.lowerBound.position ..< selection.upperBound.position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func indices(at destination: Range<Position>) -> Range<Positions.Index> {
        positions.indices(start: selection, destination: destination)
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
        //=--------------------------------------=
        // MARK: Positions
        //=--------------------------------------=
        let positions = Positions(snapshot)
        //=--------------------------------------=
        // MARK: Selection - Upper Bound
        //=--------------------------------------=
        let upperBound = Changes.end(
            past: self.positions[self.selection.upperBound...],
            next: positions).next
        //=--------------------------------------=
        // MARK: Selection - Lower Bound
        //=--------------------------------------=
        var lowerBound = upperBound
        if !self.selection.isEmpty {
            lowerBound = Changes.start(
                past: self.positions[...self.selection.lowerBound],
                next: positions).next
            lowerBound = min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Selection
        //=--------------------------------------=
        let selection = lowerBound ..< upperBound
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.positions = positions
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
    
    @inlinable mutating func update(selection: Range<Positions.Index>, intent: Direction?) {
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
        let upperBound = positions.caret(start: selection.upperBound, preference: .backwards, intent: intent.upper)
        var lowerBound = upperBound
        
        if !selection.isEmpty, upperBound != positions.startIndex {
            lowerBound = positions.caret(start: selection.lowerBound, preference:  .forwards, intent: intent.lower)
            lowerBound = min(lowerBound, upperBound)
        }
                
        self.selection = lowerBound ..< upperBound
    }
}
