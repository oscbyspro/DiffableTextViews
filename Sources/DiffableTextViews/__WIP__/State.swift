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

@usableFromInline struct State {

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var snapshot:  Snapshot
    @usableFromInline private(set) var selection: Range<Snapshot.Index>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.snapshot  = Snapshot()
        self.selection = snapshot.endIndex..<snapshot.endIndex
    }
    
    @inlinable init(snapshot: Snapshot, selection: Range<Snapshot.Index>) {
        self.snapshot  = snapshot
        self.selection = selection
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
            past: self.snapshot[self.selection.upperBound...],
            next: snapshot[...]).next
        //=--------------------------------------=
        // MARK: Lower
        //=--------------------------------------=
        var lowerBound = upperBound
        if !self.selection.isEmpty {
            lowerBound = changesStartIndices(
                past: self.snapshot[...self.selection.lowerBound],
                next: snapshot[...]).next
            lowerBound = min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.snapshot  = snapshot
        self.selection = lowerBound ..< upperBound
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
    
    @inlinable mutating func update(selection: Range<Snapshot.Index>, intent: Direction?) {
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
    
    @inlinable func position(start: Snapshot.Index, preference: Direction, intent: Direction?) -> Snapshot.Index {
        //=--------------------------------------=
        // MARK: Position, Direction
        //=--------------------------------------=
        var position  = start
        var direction = direction(at: start) ?? intent ?? preference
        //=--------------------------------------=
        // MARK: Correct
        //=--------------------------------------=
        loop: while true {
            //=----------------------------------=
            // MARK: Move To Next Position
            //=----------------------------------=
            position = move(start: position, direction: direction)
            //=----------------------------------=
            // MARK: Break Loop Or Jump To Side
            //=----------------------------------=
            switch direction {
            case preference: break loop
            case  .forwards: position = (position != snapshot  .endIndex) ? snapshot.index(after:  position) : position
            case .backwards: position = (position != snapshot.startIndex) ? snapshot.index(before: position) : position
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

//=----------------------------------------------------------------------------=
// MARK: State - Move
//=----------------------------------------------------------------------------=

extension State {

    //=------------------------------------------------------------------------=
    // MARK: Direction
    //=------------------------------------------------------------------------=
    
    @inlinable func move(start: Snapshot.Index, direction: Direction) -> Snapshot.Index {
        switch direction {
        case  .forwards: return  forwards(start: start)
        case .backwards: return backwards(start: start)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=
    
    @inlinable func forwards(start: Snapshot.Index) -> Snapshot.Index {
        var position = start
        
        while position != snapshot.endIndex {
            if !snapshot[position].attribute.contains(.prefixing) { return position }
            snapshot.formIndex(after: &position)
        }
        
        return position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards
    //=------------------------------------------------------------------------=
    
    @inlinable func backwards(start: Snapshot.Index) -> Snapshot.Index {
        var position = start
        
        while position != snapshot.startIndex {
            let after = position
            snapshot.formIndex(before: &position)
            if !snapshot[position].attribute.contains(.suffixing) { return after }
        }
        
        return position
    }
}

//=----------------------------------------------------------------------------=
// MARK: State - Inspect
//=----------------------------------------------------------------------------=

extension State {
    
    //=------------------------------------------------------------------------=
    // MARK: Direction
    //=------------------------------------------------------------------------=
    
    @inlinable func direction(at position: Snapshot.Index) -> Direction? {
        let peek = peek(at: position)

        let forwards  = peek.lhs.contains(.prefixing) && peek.rhs.contains(.prefixing)
        let backwards = peek.lhs.contains(.suffixing) && peek.rhs.contains(.suffixing)
        
        if forwards == backwards { return nil }
        return forwards ? .forwards : .backwards
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Peek
    //=------------------------------------------------------------------------=
    
    @inlinable func peek(at position: Snapshot.Index) -> (lhs: Attribute, rhs: Attribute) {(
        position != snapshot.startIndex ? snapshot[snapshot.index(before: position)].attribute : .prefixing,
        position !=   snapshot.endIndex ? snapshot[position].attribute : .suffixing
    )}
}
