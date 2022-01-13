//
//  Carets.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-13.
//

//*============================================================================*
// MARK: * Carets
//*============================================================================*

#warning("Rename as Positions, maybe.")
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
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Collections Esque
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Subscripts
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(caret: Caret) -> Symbol {
        snapshot[caret.position]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Positions
    //=------------------------------------------------------------------------=
    
    @inlinable var start: Caret {
        Caret(snapshot.startIndex, at: .zero)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Collections Esque - Traverse
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
    
    //=------------------------------------------------------------------------=
    // MARK: Multiple - Direction
    //=------------------------------------------------------------------------=
    
    @inlinable func move(caret: Caret, direction: Direction) -> Caret {
        switch direction {
        case  .forwards: return  forwards(caret)
        case .backwards: return backwards(caret)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Utilities
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable func indices(_ range: Range<Snapshot.Index>) -> Range<Caret> {
        let lowerBound = Offset(at: range.lowerBound.character, in: snapshot.characters)
        let difference = Offset(at: range.upperBound.character, in: snapshot.characters[range.lowerBound.character...])
        return Caret(range.lowerBound, at: lowerBound) ..< Caret(range.upperBound, at: lowerBound + difference)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Direction
    //=------------------------------------------------------------------------=
    
    @inlinable func direction(at caret: Caret) -> Direction? {
        let peek = peek(at: caret)

        let forwards  = peek.lhs.contains(.prefixing) && peek.rhs.contains(.prefixing)
        let backwards = peek.lhs.contains(.suffixing) && peek.rhs.contains(.suffixing)
        
        if forwards == backwards { return nil }
        return forwards ? .forwards : .backwards
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Peek
    //=------------------------------------------------------------------------=
    
    @inlinable func peek(at caret: Caret) -> (lhs: Attribute, rhs: Attribute) {(
        caret.position != snapshot.startIndex ? snapshot[snapshot.index(before: caret.position)].attribute : .prefixing,
        caret.position !=   snapshot.endIndex ? snapshot[caret.position].attribute : .suffixing
    )}
}
