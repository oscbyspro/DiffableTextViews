//
//  Carets.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-13.
//

#warning("WIP")
#warning("WIP")
#warning("WIP")

//*============================================================================*
// MARK: * Carets
//*============================================================================*

@usableFromInline struct Carets<Scheme: DiffableTextViews.Scheme>: BidirectionalCollection {
    @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let snapshot: Snapshot
    
    //=------------------------------------------------------------------------=
    // MARK: Properties - Indices
    //=------------------------------------------------------------------------=
    
    @usableFromInline let startIndex: Index
    @usableFromInline let   endIndex: Index
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @usableFromInline init(_ snapshot: Snapshot) {
        self.snapshot = snapshot
        self.startIndex = Index(snapshot.startIndex, at: .zero)
        self  .endIndex = Index(snapshot  .endIndex, at: .size(of: snapshot.characters))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var characters: Snapshot.Characters {
        snapshot.characters
    }
    
    @inlinable var attributes: Snapshot.Attributes {
        snapshot.attributes
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Subscripts
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(position: Index) -> Symbol {
        snapshot[position.snapshot]
    }

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    #warning("Remove.")
    @inlinable func acceptable(_ position: Index, preference: Direction) -> Bool {
        switch preference {
        case  .forwards: return !peek(position).rhs.contains(.prefixing)
        case .backwards: return !peek(position).lhs.contains(.suffixing)
        }
    }
    
    //*========================================================================*
    // MARK: * Index
    //*========================================================================*
    
    @usableFromInline struct Index: Comparable {
        
        //=------------------------------------------------------------------------=
        // MARK: Properties
        //=------------------------------------------------------------------------=
        
        @usableFromInline let snapshot: Snapshot.Index
        @usableFromInline let offset: Offset

        //=------------------------------------------------------------------------=
        // MARK: Initializers
        //=------------------------------------------------------------------------=
        
        @inlinable init(_ snapshot: Snapshot.Index, at offset: Offset) {
            self.snapshot = snapshot
            self.offset = offset
        }
        
        //=------------------------------------------------------------------------=
        // MARK: Accessors
        //=------------------------------------------------------------------------=
        
        @inlinable var character: Snapshot.Characters.Index {
            snapshot.character
        }
        
        @inlinable var attribute: Snapshot.Attributes.Index {
            snapshot.attribute
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
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Move
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=
    
    @inlinable func index(after position: Index) -> Index {
        let index = snapshot.index(after: position.snapshot)
        let character = characters[position.character]
        return Index(index, at: position.offset + .size(of: character))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards
    //=------------------------------------------------------------------------=
    
    @inlinable func index(before position: Index) -> Index {
        let index = snapshot.index(before: position.snapshot)
        let character = characters[index.character]
        return Index(index, at: position.offset - .size(of: character))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Move In Direction
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Dynamic
    //=------------------------------------------------------------------------=
    
    @inlinable func index(start: Index, direction: Direction) -> Index {
        switch direction {
        case  .forwards: return self[start...].firstIndex(where: \.nonprefixing) ??   endIndex
        case .backwards: return self[..<start] .lastIndex(where: \.nonsuffixing) ?? startIndex
        }
    }
    
    @inlinable func breakpoint(forwards start: Index) -> Index {
        var position = start
        
        while position != endIndex {
            if !attributes[position.attribute].contains(.prefixing) { return position }
            formIndex(after: &position)
        }
        
        return position
    }
    
    @inlinable func breakpoint(backwards start: Index) -> Index {
        var position = start
        
        while position != startIndex {
            
        }
        
        return position
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Move To Destination
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Dynamic - One
    //=------------------------------------------------------------------------=
        
    @inlinable func index(start: Index, destination: Offset) -> Index {
        switch start.offset <= destination {
        case true:  return indices[start...].first(where: { $0.offset >= destination }) ??   endIndex
        case false: return indices[..<start] .last(where: { $0.offset <= destination }) ?? startIndex
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Dynamic - Two
    //=------------------------------------------------------------------------=
    
    @inlinable func indices(start: Range<Index>, destination: Range<Offset>) -> Range<Index> {
        let upperBound = index(start: start.upperBound, destination: destination.upperBound)
        var lowerBound = upperBound
        
        if !destination.isEmpty {
            lowerBound = index(start: start.lowerBound, destination: destination.lowerBound)
            lowerBound = Swift.min(lowerBound, upperBound)
        }
        
        return lowerBound ..< upperBound
    }
}

//=----------------------------------------------------------------------------=
// MARK: Carets - Utilities
//=----------------------------------------------------------------------------=

extension Carets {
    
    //=------------------------------------------------------------------------=
    // MARK: Direction
    //=------------------------------------------------------------------------=
    
    @inlinable func direction(at position: Index) -> Direction? {
        let peek = peek(position)

        let forwards  = peek.lhs.contains(.prefixing) && peek.rhs.contains(.prefixing)
        let backwards = peek.lhs.contains(.suffixing) && peek.rhs.contains(.suffixing)
        
        if forwards == backwards { return nil }
        return forwards ? .forwards : .backwards
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Peek
    //=------------------------------------------------------------------------=
    
    @inlinable func peek(_ position: Index) -> (lhs: Attribute, rhs: Attribute) {(
        //=--------------------------------------=
        // MARK: LHS
        //=--------------------------------------=
        position.snapshot != snapshot.startIndex
        ? snapshot[snapshot.index(before: position.snapshot)].attribute : .prefixing,
        //=--------------------------------------=
        // MARK: RHS
        //=--------------------------------------=
        position.snapshot != snapshot.endIndex
        ? snapshot[position.snapshot].attribute : .suffixing
    )}
}
