//
//  Caret.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-15.
//

//*============================================================================*
// MARK: * Caret
//*============================================================================*

@usableFromInline protocol Caret {
    associatedtype Scheme: DiffableTextViews.Scheme
    typealias Positions = DiffableTextViews.Positions<Scheme>
    typealias Index = DiffableTextViews.Positions<Scheme>.Index
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @inlinable var positions:  Positions { get }
    @inlinable var preference: Direction { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Validate
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(start: Index) -> Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Traverse
    //=------------------------------------------------------------------------=
    
    @inlinable func  forwards(start: Index) -> Index?
    @inlinable func backwards(start: Index) -> Index?    
}

//=----------------------------------------------------------------------------=
// MARK: Caret - Convenience
//=----------------------------------------------------------------------------=

extension Caret {
    
    //=------------------------------------------------------------------------=
    // MARK: Attribute
    //=------------------------------------------------------------------------=
    
    @inlinable func attribute(_ position: Index) -> Attribute {
        positions.attributes[position.attribute]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Passthrough
    //=------------------------------------------------------------------------=
    
    @inlinable func passthrough(_ position: Index) -> Bool {
        attribute(position).contains(.passthrough)
    }
    
    @inlinable func lookaheadable(_ position: Index) -> Bool {
        position != positions.endIndex ? passthrough(position) : true
    }
    
    @inlinable func lookbehindable(_ position: Index) -> Bool {
        position != positions.startIndex ? passthrough(positions.index(before: position)) : true
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
    
    @inlinable func position(start: Index, intent: Direction?) -> Index {
        //=--------------------------------------=
        // MARK: Validate
        //=--------------------------------------=
        if validate(start: start) { return start }
        //=--------------------------------------=
        // MARK: Direction
        //=--------------------------------------=
        let direction = intent ?? preference
        //=--------------------------------------=
        // MARK: Try, Then Try In Reverse
        //=--------------------------------------=
        if let next = move(start: start, direction: direction)            { return next }
        if let next = move(start: start, direction: direction.reversed()) { return next }
        //=--------------------------------------=
        // MARK: Failure
        //=--------------------------------------=
        return positions.startIndex
    }
}
