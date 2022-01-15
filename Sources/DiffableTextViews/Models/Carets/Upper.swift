//
//  Upper.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-15.
//

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
    // MARK: Preference
    //=------------------------------------------------------------------------=
    
    @inlinable var preference: Direction {
        .backwards
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Validate
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(start: Index) -> Bool {
        !lookbehindable(start)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Traverse
    //=------------------------------------------------------------------------=
    
    @inlinable func forwards(start: Index) -> Index? {
        var position = start
        var lookbehindable = lookbehindable(position)
        
        while position != positions.endIndex {
            if !lookbehindable {
                return position
            }
            
            lookbehindable = passthrough(position)
            positions.formIndex(after: &position)
        }

        return nil
    }
    
    @inlinable func backwards(start: Index) -> Index? {
        Single(positions).backwards(start: start)
    }
}

