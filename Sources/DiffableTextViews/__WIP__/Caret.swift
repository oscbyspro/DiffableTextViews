//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-14.
//

#warning("Ideas.")

protocol Caret {
    
//    var preference: Direction { get }
//
//    func validate() -> Bool { }
//
//    func fall() -> Positions.Index?
//
//    func climb() -> Positions.Index?
}


//*============================================================================*
// MARK: * Caret x Upper
//*============================================================================*

@usableFromInline struct UpperBound<Scheme: DiffableTextViews.Scheme>: Caret {
    @usableFromInline typealias Positions = DiffableTextViews.Positions<Scheme>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let position: Positions.Index
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable var preference: Direction {
        .backwards
    }
    
    // MARK: Utilities
    
    @inlinable func fall(in positions: Positions) -> Positions.Index? {
        positions.prefix(upTo: position).lastIndex(where: { !$0.attribute.contains(.passthrough) })
    }
    
    @inlinable func climb(in positions: Positions) -> Positions.Index? {
        positions.suffix(from: position).firstIndex(where: { !$0.attribute.contains(.passthrough) })
    }
}

//*============================================================================*
// MARK: * Caret x Lower
//*============================================================================*

@usableFromInline struct LowerBound<Scheme: DiffableTextViews.Scheme>: Caret {
    @usableFromInline typealias Positions = DiffableTextViews.Positions<Scheme>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let position: Positions.Index
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable var preference: Direction {
        .forwards
    }
    
    // MARK: Utilities
    
    @inlinable func fall(in positions: Positions) -> Positions.Index? {
//        positions.prefix(upTo: position).lastIndex(where: { !$0.attribute.contains(.passthough) })
    }
    
    @inlinable func climb(in positions: Positions) -> Positions.Index? {
//        positions.suffix(from: position).firstIndex(where: { !$0.attribute.contains(.passthough) })
    }
}
