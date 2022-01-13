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
    @usableFromInline typealias Caret  = DiffableTextViews.Caret <Scheme>
    @usableFromInline typealias Carets = DiffableTextViews.Carets<Scheme>
    @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var snapshot: Snapshot
    @usableFromInline private(set) var selection: Range<Caret>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        let snapshot = Snapshot()
        let position = Caret(snapshot.startIndex, at: .zero)
        self.init(snapshot: snapshot, selection: position ..< position)
    }
    
    @inlinable init(snapshot: Snapshot, selection: Range<Caret>) {
        self.snapshot = snapshot
        self.selection = selection
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var upperBound: Snapshot.Index {
        selection.upperBound.position
    }
    
    @inlinable var lowerBound: Snapshot.Index {
        selection.lowerBound.position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func carets(_ range: Range<Snapshot.Index>, in snapshot: Snapshot) -> Range<Caret> {
        let lowerBound = Offset(at: range.lowerBound.character, in: snapshot.characters)
        let difference = Offset(at: range.upperBound.character, in: snapshot.characters[range.lowerBound.character...])
        return Caret(range.lowerBound, at: lowerBound) ..< Caret(range.upperBound, at: lowerBound + difference)
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
        // MARK: Selection
        //=--------------------------------------=
        let selection = Self.carets(lowerBound ..< upperBound, in: snapshot)
        //=--------------------------------------=
        // MARK: Update
        //=--------------------------------------=
        self.snapshot = snapshot
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
    
    @inlinable mutating func update(selection: Range<Caret>, intent: Direction?) {
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
    
    @inlinable func position(start: Caret, preference: Direction, intent: Direction?) -> Caret {
        //=--------------------------------------=
        // MARK: Position, Direction
        //=--------------------------------------=
        var caret = start
        var direction = direction(at: start) ?? intent ?? preference
        //=--------------------------------------=
        // MARK: Correct
        //=--------------------------------------=
        loop: while true {
            //=----------------------------------=
            // MARK: Move To Next Position
            //=----------------------------------=
            caret = move(start: caret, direction: direction)
            //=----------------------------------=
            // MARK: Break Loop Or Jump To Side
            //=----------------------------------=
            switch direction {
            case preference: break loop
            case  .forwards: caret = (caret != snapshot  .endIndex) ? snapshot.index(after:  caret) : caret
            case .backwards: caret = (caret != snapshot.startIndex) ? snapshot.index(before: caret) : caret
            }
            //=----------------------------------=
            // MARK: Repeat In Preferred Direction
            //=----------------------------------=
            direction = preference
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return caret
    }
}

//=----------------------------------------------------------------------------=
// MARK: State - Move
//=----------------------------------------------------------------------------=

extension State {

    //=------------------------------------------------------------------------=
    // MARK: Direction
    //=------------------------------------------------------------------------=
    
    @inlinable func move(start: Caret, direction: Direction) -> Caret {
        switch direction {
        case  .forwards: return  forwards(start: start)
        case .backwards: return backwards(start: start)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=
    
    @inlinable func forwards(start: Caret) -> Caret {
        var current = start
        
        while current.position != snapshot.endIndex {
            if !snapshot[current].attribute.contains(.prefixing) { return current }
            snapshot.formIndex(after: &current)
        }
        
        return current
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards
    //=------------------------------------------------------------------------=
    
    @inlinable func backwards(start: Caret) -> Caret {
        var current = start
        
        while current.position != snapshot.startIndex {
            let after = current
            snapshot.formIndex(before: &current)
            if !snapshot[current].attribute.contains(.suffixing) { return after }
        }
        
        return current
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
