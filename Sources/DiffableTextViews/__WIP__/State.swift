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

@usableFromInline struct State: Mappable {

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
    
    @inlinable func updated(selection newValue: Selection, intent: Direction?) -> Self {
        func position(start: Carets.Index, preference: Direction) -> Carets.Index {
            if carets[start].nonlookable(direction: preference) { return start }
            
            let direction = intent ?? preference
            let next = carets.look(start: start, direction: direction)
            
            switch direction {
            case preference: return next
            case  .forwards: return next < carets .lastIndex ? carets.index(after:  next) : next
            case .backwards: return next > carets.startIndex ? carets.index(before: next) : next
            }
        }
        
        return map({ $0.selection = newValue.preferred(position) }).autocorrected()
    }
}
