//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-14.
//

#warning("Ideas.")

protocol Caret {

    
}

//*============================================================================*
// MARK: * Caret x UpperBound
//*============================================================================*

@usableFromInline struct UpperBound<Scheme: DiffableTextViews.Scheme>: Caret {
    @usableFromInline typealias Positions = DiffableTextViews.Positions<Scheme>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let positions: Positions
    @usableFromInline let index: Positions.Index
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(positions: Positions, index: Positions.Index) {
        self.positions = positions
        self.index = index
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable var preference: Direction {
        .backwards
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func primary() -> Attribute {
        guard index != positions.startIndex else {
            return .passthrough
        }
        
        let side = positions.index(before: index)
        return positions[side].attribute
    }
    
    @inlinable func secondary() -> Attribute {
        positions[index].attribute
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func startIsDone() -> Bool {
        primary() != .passthrough
    }
}
