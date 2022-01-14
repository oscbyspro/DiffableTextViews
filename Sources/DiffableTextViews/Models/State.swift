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
    @usableFromInline typealias Offset    = DiffableTextViews.Offset<Scheme>

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
    
    @inlinable var offsets: Range<Offset> {
        selection.lowerBound.offset ..< selection.upperBound.offset
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func indices(at range: Range<Offset>) -> Range<Positions.Index> {
        positions.indices(start: selection, destination: range)
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
    
    @inlinable mutating func update(selection: Range<Offset>, intent: Direction?) {
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
    
    /// It is OK to use intent on both positions at once, because they each have different preferred directions.
    @inlinable mutating func autocorrect(intent: Direction?) {
        let upperBound = position(start: selection.upperBound, preference: .backwards, intent: intent)
        var lowerBound = upperBound
        
        if !selection.isEmpty {
            lowerBound = position(start: selection.lowerBound, preference:  .forwards, intent: intent)
            lowerBound = min(lowerBound, upperBound)
        }
        
        self.selection = lowerBound ..< upperBound
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Position
    //=------------------------------------------------------------------------=

    #warning("Plan.")
    /*
     
     1. try to fall
     2. if both sides are passthrough, try to climb
     
     */
    
    #warning("Broken.")
    @inlinable func position(start: Positions.Index, preference: Direction, intent: Direction?) -> Positions.Index {
        //=--------------------------------------=
        // MARK: Validate
        //=--------------------------------------=
        if positions.breaks(at: start, direction: preference) { return start }
        //=--------------------------------------=
        // MARK: Position, Direction
        //=--------------------------------------=
        var position = start
        var direction = intent ?? preference
        //=--------------------------------------=
        // MARK: Correct
        //=--------------------------------------=
        loop: while true {
            //=----------------------------------=
            // MARK: Move To Next Position
            //=----------------------------------=
            position = positions.breakpoint(start: position, direction: direction)
            //=----------------------------------=
            // MARK: Correct
            //=----------------------------------=
            switch direction {
            //=----------------------------------=
            // MARK: Done
            //=----------------------------------=
            case preference:
                break loop
            //=----------------------------------=
            // MARK: Forwards
            //=----------------------------------=
            case .forwards:
                if position != positions.endIndex {
                    position = positions.index(after: position)
                }
            //=----------------------------------=
            // MARK: Backwards
            //=----------------------------------=
            case .backwards:
                if position != positions.startIndex {
                    position = positions.index(before: position)
                }
            }
            //=----------------------------------=
            // MARK: Repeat In Preferred Direction
            //=----------------------------------=
            direction = preference
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return position
    }
}
