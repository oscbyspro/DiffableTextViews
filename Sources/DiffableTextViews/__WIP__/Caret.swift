//
//  Caret.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-15.
//

//*============================================================================*
// MARK: * Caret
//*============================================================================*

/// The forwards and backwards methods must check the start position.
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
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func  forwards(start: Index) -> Index?
    @inlinable func backwards(start: Index) -> Index?
}

//=----------------------------------------------------------------------------=
// MARK: Caret - Utilities
//=----------------------------------------------------------------------------=

extension Caret {

    
    //=------------------------------------------------------------------------=
    // MARK: Traversal
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

#warning("WIP")
#warning("WIP")
#warning("WIP")

//*============================================================================*
// MARK: * Single
//*============================================================================*

@usableFromInline struct Single<Scheme: DiffableTextViews.Scheme>: Caret {
    @usableFromInline typealias Positions = DiffableTextViews.Positions<Scheme>
    @usableFromInline typealias Index = DiffableTextViews.Positions<Scheme>.Index
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let positions: Positions
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ positions: Positions) {
        self.positions = positions
    }

    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable var preference: Direction {
        .backwards
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Locate
    //=------------------------------------------------------------------------=
    
    @inlinable func forwards(start: Index) -> Index? {
        //=--------------------------------------=
        // MARK: Start
        //=--------------------------------------=
        if !positions.attribute(backwards: start.attribute).contains(.passthrough) {
            return start
        }
        //=--------------------------------------=
        // MARK: Loop
        //=--------------------------------------=
        var position = start
        while position != positions.endIndex {
            if !positions.attributes[position.attribute].contains(.passthrough) {
                return position
            }
            
            positions.formIndex(after: &position)
        }
        //=--------------------------------------=
        // MARK: Failure
        //=--------------------------------------=
        return nil
    }
    
    @inlinable func backwards(start: Index) -> Index? {
        var position = start
        //=--------------------------------------=
        // MARK: Start
        //=--------------------------------------=
        if !positions.attributes[position.attribute].contains(.passthrough) {
            return position
        }
        //=--------------------------------------=
        // MARK: Loop
        //=--------------------------------------=
        while position != positions.startIndex {
            let after = position
            positions.formIndex(before: &position)
            if !positions.attributes[position.attribute].contains(.passthrough) {
                return after
            }
        }
        //=--------------------------------------=
        // MARK: Failure
        //=--------------------------------------=
        return nil
    }
}
