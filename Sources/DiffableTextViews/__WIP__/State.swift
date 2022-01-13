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
    // MARK: WIP
    //=------------------------------------------------------------------------=
    
    #warning("WIP")
    @inlinable mutating func position(caret: Snapshot.Index, preference: Direction, intent: Direction?) -> Snapshot.Index {
        let direction = directionality(at: caret) ?? intent ?? preference
        let next = look(start: caret, direction: direction)
        
        switch direction {
        case preference: return next
        case  .forwards: return next != snapshot  .endIndex ? snapshot.index(after:  next) : next
        case .backwards: return next != snapshot.startIndex ? snapshot.index(before: next) : next
        }
    }
    
    #warning("WIP")
    @inlinable func directionality(at position: Snapshot.Index) -> Direction? {
        let lhs = position == snapshot.startIndex ? .prefixing : snapshot[snapshot.index(before: position)].attribute
        let rhs = position == snapshot  .endIndex ? .suffixing : snapshot[position].attribute

        let forwards  = lhs.contains(.prefixing) && rhs.contains(.prefixing)
        let backwards = lhs.contains(.suffixing) && rhs.contains(.suffixing)
        
        if forwards == backwards { return nil }
        return forwards ? .forwards : .backwards
    }
    
    //=------------------------------------------------------------------------=
    // MARK: #warning("WIP")
    //=------------------------------------------------------------------------=
    
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
// MARK: State - Look In Direction
//=----------------------------------------------------------------------------=

extension State {
    
    //=------------------------------------------------------------------------=
    // MARK: Direction
    //=------------------------------------------------------------------------=
    
    @inlinable func look(start: Snapshot.Index, direction: Direction) -> Snapshot.Index? {
        switch direction {
        case  .forwards: return lookahead (start: start)
        case .backwards: return lookbehind(start: start)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=
    
    /// - Returns: The first caret position « forwards » that is nonprefixing.
    @inlinable func lookahead(start: Snapshot.Index) -> Snapshot.Index? {
        var position = start
        
        while position != snapshot.endIndex {
            guard snapshot[position].attribute.contains(.prefixing) else { return position }
            snapshot.formIndex(after: &position)
        }
        
        return position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards
    //=------------------------------------------------------------------------=
    
    /// - Returns: The first caret position « backwards » that is nonsuffixing.
    @inlinable func lookbehind(start: Snapshot.Index) -> Snapshot.Index? {
        var position = start
        
        while position != snapshot.startIndex {
            let after = position
            snapshot.formIndex(before: &position)
            guard snapshot[position].attribute.contains(.suffixing) else { return after }
        }
        
        return position
    }
}
