//
//  Single.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-15.
//

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
    // MARK: Preference
    //=------------------------------------------------------------------------=
    
    @inlinable var preference: Direction {
        .backwards
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Validate
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(start: Index) -> Bool {
        !lookbehindable(start) || !lookaheadable(start)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Traverse
    //=------------------------------------------------------------------------=
    
    @inlinable func forwards(start: Index) -> Index? {
        var position = start
        //=--------------------------------------=
        // MARK: Loop
        //=--------------------------------------=
        while position != positions.endIndex {
            //=----------------------------------=
            // MARK: Validate
            //=----------------------------------=
            if !passthrough(position) {
                return position
            }
            //=----------------------------------=
            // MARK: Continue
            //=----------------------------------=
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
        // MARK: Attempt
        //=--------------------------------------=
        while position != positions.startIndex {
            //=--------------------------------------=
            // MARK: Scry
            //=--------------------------------------=
            let after = position
            positions.formIndex(before: &position)
            //=--------------------------------------=
            // MARK: Validate
            //=--------------------------------------=
            if !passthrough(position) { return after }
        }
        //=--------------------------------------=
        // MARK: Failure
        //=--------------------------------------=
        return nil
    }
}

//*============================================================================*
// MARK: Positions x Single
//*============================================================================*

extension Positions {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable var single: Single<Scheme> {
        Single(self)
    }
}
