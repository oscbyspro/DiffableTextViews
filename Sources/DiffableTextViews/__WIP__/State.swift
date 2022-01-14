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
    @usableFromInline typealias Carets = DiffableTextViews.Carets<Scheme>
    @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var carets: Carets
    @usableFromInline var selection: Range<Carets.Index>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        let carets = Carets(Snapshot())
        self.init(carets: carets, selection: carets.startIndex ..< carets.startIndex)
    }
    
    @inlinable init(carets: Carets, selection: Range<Carets.Index>) {
        self.carets = carets
        self.selection = selection
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var snapshot: Snapshot {
        carets.snapshot
    }
    
    @inlinable var offsets: Range<Offset> {
        selection.lowerBound.offset ..< selection.upperBound.offset
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func indices(at range: Range<Offset>) -> Range<Carets.Index> {
        carets.indices(at: range, start: selection)
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
        // MARK: Carets
        //=--------------------------------------=
        let carets = Carets(snapshot)
        //=--------------------------------------=
        // MARK: Selection - Upper Bound
        //=--------------------------------------=
        let upperBound = Changes.end(
            past: self.carets[self.selection.upperBound...],
            next: carets).next
        //=--------------------------------------=
        // MARK: Selection - Lower Bound
        //=--------------------------------------=
        var lowerBound = upperBound
        if !self.selection.isEmpty {
            lowerBound = Changes.start(
                past: self.carets[...self.selection.lowerBound],
                next: carets).next
            lowerBound = min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Selection
        //=--------------------------------------=
        let selection = lowerBound ..< upperBound
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.carets = carets
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
    
    @inlinable mutating func update(selection: Range<Carets.Index>, intent: Direction?) {
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
    
    /// It is OK to use intent on both carets at once, because they each have different preferred directions.
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
    
    @inlinable func position(start: Carets.Index, preference: Direction, intent: Direction?) -> Carets.Index {
        //=--------------------------------------=
        // MARK: Position, Direction
        //=--------------------------------------=
        var position = start
        var direction = carets.direction(at: position) ?? intent ?? preference
        //=--------------------------------------=
        // MARK: Correct
        //=--------------------------------------=
        loop: while true {
            //=----------------------------------=
            // MARK: Move To Next Position
            //=----------------------------------=
            position = carets.move(position: position, direction: direction)
            //=----------------------------------=
            // MARK: Select
            //=----------------------------------=
            switch direction {
                //=------------------------------=
                // MARK: Break
                //=------------------------------=
            case preference:
                break loop
                //=------------------------------=
                // MARK: Forwards
                //=------------------------------=
            case  .forwards:
                if position.snapshot != snapshot.endIndex {
                    position = carets.index(after:  position)
                }
                //=------------------------------=
                // MARK: Backwards
                //=------------------------------=
            case .backwards:
                if position.snapshot != snapshot.startIndex {
                    position = carets.index(before: position)
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
