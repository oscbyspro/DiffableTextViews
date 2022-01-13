//
//  Carets.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-13.
//

//*============================================================================*
// MARK: * Carets
//*============================================================================*

@usableFromInline struct Carets<Scheme: DiffableTextViews.Scheme> {
    @usableFromInline typealias Caret = DiffableTextViews.Caret<Scheme>
    @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let snapshot: Snapshot
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @usableFromInline init(_ snapshot: Snapshot) {
        self.snapshot = snapshot
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Positions
    //=------------------------------------------------------------------------=
    
    @inlinable var start: Caret {
        Caret(snapshot.startIndex, at: .zero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Subscripts
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(caret: Caret) -> Symbol {
        snapshot[caret.position]
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Traverse
//=----------------------------------------------------------------------------=

extension Carets {
        
    //=------------------------------------------------------------------------=
    // MARK: Single
    //=------------------------------------------------------------------------=
    
    @inlinable func after(_ caret: Caret) -> Caret {
        let index = snapshot.index(after:   caret.position)
        let character = snapshot.characters[caret.position.character]
        return Caret(index, at: caret.offset + .size(of: character))
    }
    
    @inlinable func before(_ caret: Caret) -> Caret {
        let index = snapshot.index(before:  caret.position)
        let character = snapshot.characters[index.character]
        return Caret(index, at: caret.offset + .size(of: character))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Multiple
    //=------------------------------------------------------------------------=
    
    @inlinable func forwards(_ caret: Caret) -> Caret {
        var current = caret
        
        while current.position != snapshot.endIndex {
            if !snapshot.attributes[current.position.attribute].contains(.prefixing) { return current }
            current = after(current)
        }
        
        return current
    }
    
    @inlinable func backwards(_ caret: Caret) -> Caret {
        var current = caret
        
        while current.position != snapshot.startIndex {
            let after = current
            current = before(current)
            if !snapshot.attributes[current.position.attribute].contains(.suffixing) { return after }
        }
        
        return current
    }
}
