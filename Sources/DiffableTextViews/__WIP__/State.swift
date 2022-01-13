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

#warning("Needs: Scheme.")
@usableFromInline struct State<Scheme: DiffableTextViews.Scheme> {
    @usableFromInline typealias Carets = DiffableTextViews.Carets<Scheme>
    @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var carets: Carets
    @usableFromInline private(set) var selection: Range<Carets.Index>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        let carets = Carets(Snapshot())
        self.init(carets: carets, selection: carets.start ..< carets.start)
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
    
    @inlinable var upperBound: Snapshot.Index {
        selection.upperBound.snapshot
    }
    
    @inlinable var lowerBound: Snapshot.Index {
        selection.lowerBound.snapshot
    }
    
    @inlinable var offsets: Range<Offset> {
        selection.lowerBound.offset ..< selection.upperBound.offset
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
        // MARK: Upper
        //=--------------------------------------=
        let upperBound = changesEndIndices(
            past: self.snapshot[self.upperBound...],
            next: snapshot[...]).next
        //=--------------------------------------=
        // MARK: Lower
        //=--------------------------------------=
        var lowerBound = upperBound
        if !self.selection.isEmpty {
            lowerBound = changesStartIndices(
                past: self.snapshot[...self.lowerBound],
                next: snapshot[...]).next
            lowerBound = min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Values
        //=--------------------------------------=
        let carets = Carets(snapshot)
        let selection = carets.indices(lowerBound ..< upperBound)
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
            // MARK: Break Loop Or Jump To Side
            //=----------------------------------=
            switch direction {
            case preference: break loop
            case  .forwards: position = (position.snapshot != snapshot  .endIndex) ? carets .after(position) : position
            case .backwards: position = (position.snapshot != snapshot.startIndex) ? carets.before(position) : position
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
