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
        self.autocorrect(intent: nil)
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
    
    /// It is OK to use momentum on both positions at once, because they each have different preferred directions.
    @inlinable mutating func autocorrect(intent: Direction?) {
        switch selection.isEmpty {
        case  true: autocorrectSingleCaret(intent: intent)
        case false: autocorrectDoubleCaret(intent: intent)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Single
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func autocorrectSingleCaret(intent: Direction?) {
        let position = positions.single.position(start: selection.upperBound, intent: intent)
        self.selection = position ..< position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Double
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func autocorrectDoubleCaret(intent: Direction?) {
        let upperBound = positions.upper.position(start: selection.upperBound, intent: intent)
        var lowerBound = upperBound

        if upperBound != positions.startIndex {
            lowerBound = positions.lower.position(start: selection.lowerBound, intent: intent)
            lowerBound = min(lowerBound, upperBound)
        }
        
        self.selection = lowerBound ..< upperBound
    }
}
