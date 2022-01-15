//
//  Caret.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-15.
//

//*============================================================================*
// MARK: * Caret
//*============================================================================*

@usableFromInline protocol Caret: BidirectionalCollection where Index == Positions.Index {
    associatedtype Scheme: DiffableTextViews.Scheme
    typealias Positions = DiffableTextViews.Positions<Scheme>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @inlinable var positions:  Positions { get }
    @inlinable var preference: Direction { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Validate
    //=------------------------------------------------------------------------=
    
    @inlinable func  validate(start: Index) -> Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Traverse
    //=------------------------------------------------------------------------=
    
    @inlinable func  forwards(start: Index) -> Index?
    @inlinable func backwards(start: Index) -> Index?    
}

//=------------------------------------------------------------------------=
// MARK: Caret - Collection
//=------------------------------------------------------------------------=

extension Caret {
    
    //=------------------------------------------------------------------------=
    // MARK: Elements
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(position: Index) -> Attribute {
        positions.attributes[position.attribute]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable var startIndex: Index {
        positions.startIndex
    }
    
    @inlinable var endIndex: Index {
        positions.endIndex
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Traverse
    //=------------------------------------------------------------------------=
    
    @inlinable func index(after position: Index) -> Index {
        positions.index(after: position)
    }
    
    @inlinable func index(before position: Index) -> Index {
        positions.index(before: position)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Caret - Helpers
//=----------------------------------------------------------------------------=

extension Caret {
    
    //=------------------------------------------------------------------------=
    // MARK: Passthrough
    //=------------------------------------------------------------------------=
    
    @inlinable func passthrough(_ position: Index) -> Bool {
        self[position].contains(.passthrough)
    }
    
    @inlinable func lookaheadable(_ position: Index) -> Bool {
        position != endIndex ? passthrough(position) : true
    }
    
    @inlinable func lookbehindable(_ position: Index) -> Bool {
        position != startIndex ? passthrough(index(before: position)) : true
    }
}

//=----------------------------------------------------------------------------=
// MARK: Caret - Utilities
//=----------------------------------------------------------------------------=

extension Caret {
    
    //=------------------------------------------------------------------------=
    // MARK: Move
    //=------------------------------------------------------------------------=
    
    @inlinable func move(start: Index, direction: Direction) -> Index? {
        switch direction {
        case  .forwards: return  forwards(start: start)
        case .backwards: return backwards(start: start)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(position: Index, intent: Direction?) -> Index? {
        //=--------------------------------------=
        // MARK: Validate
        //=--------------------------------------=
        if validate(start: position) { return position }
        //=--------------------------------------=
        // MARK: Choose A Direction
        //=--------------------------------------=
        let direction = intent ?? preference
        //=--------------------------------------=
        // MARK: Try It, Try The Other
        //=--------------------------------------=
        if let next = move(start: position, direction: direction)            { return next }
        if let next = move(start: position, direction: direction.reversed()) { return next }
        //=--------------------------------------=
        // MARK: No Acceptable Position Found
        //=--------------------------------------=
        return nil
    }
}
