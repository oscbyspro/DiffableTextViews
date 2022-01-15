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
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func  validate(start: Index) -> Bool
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
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(start: Index) -> Bool {
        !positions.attribute(forwards:  start.attribute).contains(.passthrough) ||
        !positions.attribute(backwards: start.attribute).contains(.passthrough)
    }
    
    @inlinable func forwards(start: Index) -> Index? {
        var position = start

        while position != positions.endIndex {
            if !positions.attributes[position.attribute].contains(.passthrough) {
                return position
            }
            
            positions.formIndex(after: &position)
        }

        return nil
    }
    
    @inlinable func backwards(start: Index) -> Index? {
        var position = start

        while position != positions.startIndex {
            let after = position
            positions.formIndex(before: &position)
            if !positions.attributes[position.attribute].contains(.passthrough) {
                return after
            }
        }

        return nil
    }
}

#warning("WIP")
#warning("WIP")
#warning("WIP")

//*============================================================================*
// MARK: * Upper
//*============================================================================*

@usableFromInline struct Upper<Scheme: DiffableTextViews.Scheme>: Caret {
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
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(start: Index) -> Bool {
        !positions.attribute(backwards: start.attribute).contains(.passthrough)
    }
    
    @inlinable func forwards(start: Index) -> Index? {
        var position  = start
        var backwards = positions.attribute(backwards: start.attribute)
        
        while position != positions.endIndex, backwards.contains(.passthrough) {
            backwards = positions.attributes[position.attribute]
            positions.formIndex(after: &position)
        }

        return nil
    }
    
    @inlinable func backwards(start: Index) -> Index? {
        Single(positions).backwards(start: start)
    }
}

#warning("WIP")
#warning("WIP")
#warning("WIP")

@usableFromInline struct Lower<Scheme: DiffableTextViews.Scheme>: Caret {
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
        .forwards
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(start: Index) -> Bool {
        !positions.attribute(forwards: start.attribute).contains(.passthrough)
    }
    
    @inlinable func forwards(start: Index) -> Index? {
        Single(positions).forwards(start: start)
    }
    
    @inlinable func backwards(start: Index) -> Index? {
        var position = start
        var forwards = positions.attribute(forwards: start.attribute)
        
        while position != positions.startIndex, forwards.contains(.passthrough) {
            positions.formIndex(before: &position)
            forwards = positions.attributes[position.attribute]
        }

        return nil
    }
}
