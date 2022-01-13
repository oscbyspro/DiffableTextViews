//
//  Caret.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-13.
//

//*============================================================================*
// MARK: * Caret
//*============================================================================*

@usableFromInline struct Caret<Scheme: DiffableTextViews.Scheme> {
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
    
    @inlinable init(position: Index, at offset: Offset) {
        self.position = position
        self.offset = offset
    }
}

