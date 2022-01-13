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
    // MARK: #warning("WIP")
    //=------------------------------------------------------------------------=
    
    #warning("WIP")
    @inlinable func position(start: Snapshot.Index, preference: Direction, intent: Direction?) -> Snapshot.Index {
        if peek(at: start).nonlookable(direction: preference) { return start }
        
        let direction = intent ?? preference
        let next = look(start: start, direction: direction)
        
        switch direction {
        case preference: return next
        case  .forwards: return next != snapshot  .endIndex ? snapshot.index(after:  next) : next
        case .backwards: return next != snapshot.startIndex ? snapshot.index(before: next) : next
        }
    }

    #warning("WIP")
    @inlinable func look(start: Snapshot.Index, direction: Direction) -> Snapshot.Index {
        switch direction {
        case  .forwards: return snapshot[start...].firstIndex(where: \.nonprefixing) ?? snapshot  .endIndex
        case .backwards: return snapshot[...start] .lastIndex(where: \.nonsuffixing) ?? snapshot.startIndex
        }
    }
    
    #warning("WIP")
    @inlinable func peek(at position: Snapshot.Index) -> Peek {
        let lhs = position != snapshot.startIndex ? snapshot.index(before: position) : nil
        let rhs = position != snapshot  .endIndex ? position : nil
        return Peek(lhs: lhs.map({ snapshot[$0] }), rhs: rhs.map({ snapshot[$0] }))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Update - Attributes
//=----------------------------------------------------------------------------=

extension State {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func autocorrect() {
        func position(start: Snapshot.Index, preference: Direction) -> Snapshot.Index {
            look(start: start, direction: peek(at: start).directionality() ?? preference)
        }
        
        let upperBound = position(start: selection.upperBound, preference: .backwards)
        var lowerBound = upperBound

        if !selection.isEmpty {
            lowerBound = position(start: selection.lowerBound, preference:  .forwards)
            lowerBound = min(lowerBound, upperBound)
        }
        
        self.selection = lowerBound..<upperBound
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
        // MARK: Single
        //=--------------------------------------=
        let upperBound = Changes(from: self.snapshot[self.selection.upperBound...], to: snapshot[...]).end().next
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !self.selection.isEmpty {
            lowerBound = Changes(from: self.snapshot[...self.selection.lowerBound], to: snapshot[...]).start().next
            lowerBound = min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Properties
        //=--------------------------------------=
        self.snapshot  = snapshot
        self.selection = lowerBound..<upperBound
        #warning("Autocorrect...")
    }
}

//=----------------------------------------------------------------------------=
// MARK: Update - Selection
//=----------------------------------------------------------------------------=

extension State {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(selection: Range<Snapshot.Index>) {
        self.selection = selection
        #warning("Autocorrect.")
    }
}
