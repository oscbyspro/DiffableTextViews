//
//  Lower.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-15.
//

//*============================================================================*
// MARK: * Lower
//*============================================================================*

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
    // MARK: Preference
    //=------------------------------------------------------------------------=
    
    @inlinable var preference: Direction {
        .forwards
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Validate
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(start: Index) -> Bool {
        !lookaheadable(start)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Traverse
    //=------------------------------------------------------------------------=
    
    @inlinable func forwards(start: Index) -> Index? {
        Single(positions).forwards(start: start)
    }
    
    @inlinable func backwards(start: Index) -> Index? {
        var position = start
        
        while position != positions.startIndex {
            if !passthrough(position) {
                return position
            }
            
            positions.formIndex(before: &position)
        }

        return nil
    }
}
