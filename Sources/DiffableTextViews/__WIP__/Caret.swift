//
//  Caret.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-13.
//

#warning("Remake: Carets.")

//*============================================================================*
// MARK: * Caret
//*============================================================================*

@usableFromInline struct Caret<Scheme: DiffableTextViews.Scheme>: Comparable {
    @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>
    @usableFromInline typealias Index = Snapshot.Index
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let position: Index
    @usableFromInline let offset: Offset

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ position: Index, at offset: Offset) {
        self.position = position
        self.offset = offset
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.offset == rhs.offset
    }
    
    @inlinable static func <  (lhs: Self, rhs: Self) -> Bool {
        lhs.offset <  rhs.offset
    }
}
