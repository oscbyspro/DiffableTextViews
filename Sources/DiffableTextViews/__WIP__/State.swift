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

    //=------------------------------------------------------------------------=
    // MARK: Transformations - Snapshot
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(snapshot newSnapshot: Snapshot) {
        //=--------------------------------------=
        // MARK: Bounds
        //=--------------------------------------=
        let newUpperBound = Changes(from: snapshot[selection.upperBound...], to: newSnapshot[...]).end().next
        var newLowerBound = newUpperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !selection.isEmpty {
            newLowerBound = Changes(from: snapshot[...selection.lowerBound], to: newSnapshot[...]).start().next
            newLowerBound = min(newLowerBound, newUpperBound)
        }
        //=--------------------------------------=
        // MARK: Selection
        //=--------------------------------------=
        let newSelection = newLowerBound..<newUpperBound
        //=--------------------------------------=
        // MARK: Set
        //=--------------------------------------=
        self.snapshot  = newSnapshot
        self.selection = newSelection
        #warning("Autocorrect...")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations - Selection
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(intent: Direction?) {
        func position(start: Snapshot.Index, preference: Direction) -> Snapshot.Index {
            if peek(at: start).nonlookable(direction: preference) { return start }
            
            let direction = intent ?? preference
            let next = look(start: start, direction: direction)
            
            switch direction {
            case preference: return next
            case  .forwards: return next != snapshot  .endIndex ? snapshot.index(after:  next) : next
            case .backwards: return next != snapshot.startIndex ? snapshot.index(before: next) : next
            }
        }
        
        let nextUpperBound = position(start: selection.upperBound, preference: .backwards)
        var nextLowerBound = nextUpperBound

        if !selection.isEmpty {
            nextLowerBound = position(start: selection.lowerBound, preference:  .forwards)
            nextLowerBound = min(nextLowerBound, nextUpperBound)
        }
        
        self.selection = nextLowerBound..<nextUpperBound
        #warning("Autocorrect.")
    }
}

//=----------------------------------------------------------------------------=
// MARK: #warning("Work in progress.")
//=----------------------------------------------------------------------------=

#warning("WIP")
extension State {
    
    //=------------------------------------------------------------------------=
    // MARK: WIP
    //=------------------------------------------------------------------------=
    
    @inlinable func look(start: Snapshot.Index, direction: Direction) -> Snapshot.Index {
        switch direction {
        case  .forwards: return snapshot[start...].firstIndex(where: \.nonprefixing) ?? snapshot  .endIndex
        case .backwards: return snapshot[...start] .lastIndex(where: \.nonsuffixing) ?? snapshot.startIndex
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: #warning("Work in progress.")
//=----------------------------------------------------------------------------=

#warning("WIP")
extension State {
    
    //=------------------------------------------------------------------------=
    // MARK: WIP
    //=------------------------------------------------------------------------=
    
    @inlinable func peek(at position: Snapshot.Index) -> Peek {
        let lhs = position != snapshot.startIndex ? snapshot.index(before: position) : nil
        let rhs = position != snapshot  .endIndex ? position : nil
        return Peek(lhs: lhs.map({ snapshot[$0] }), rhs: rhs.map({ snapshot[$0] }))
    }
}
