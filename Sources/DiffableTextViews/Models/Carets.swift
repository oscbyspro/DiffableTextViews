//
//  Carets.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-04.
//

import protocol Utilities.Nonempty

// MARK: - Carets

@usableFromInline struct Carets<Scheme: DiffableTextViews.Scheme>: BidirectionalCollection, Nonempty {
    @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>
    
    // MARK: Properties
    
    @usableFromInline let snapshot: Snapshot
    @usableFromInline let range: Range<Offset>

    // MARK: Initializers

    /// It might be possible to fetch the range from the view, as opposed to calculating it for each instance of this object.
    @inlinable init(_ snapshot: Snapshot) {
        self.snapshot = snapshot
        self.range = .origin ..< .max(in: snapshot.characters)
    }
    
    // MARK: Collection: Bounds
    
    @inlinable var startIndex: Index {
        Index(at: range.lowerBound, lhs: nil, rhs: snapshot.startIndex)
    }
    
    @inlinable var endIndex: Index {
        Index(at: range.upperBound, lhs: snapshot.endIndex, rhs: nil)
    }
    
    // MARK: Collection: Traversals
    
    @inlinable func index(after i: Index) -> Index {
        Index(at: i.offset.after(character(at: i.rhs!.character)), lhs: i.rhs!, rhs: subindex(after: i.rhs!))
    }
    
    @inlinable func index(before i: Index) -> Index {
        Index(at: i.offset.before(character(at: i.lhs!.character)), lhs: subindex(before: i.lhs!), rhs: i.lhs!)
    }
    
    // MARK: Collection: Subscripts
    
    @inlinable subscript(position: Index) -> Peek {
        .init(lhs: subelement(at: position.lhs), rhs: subelement(at: position.rhs))
    }
    
    // MARK: Helpers: Character
    
    @inlinable func character(at index: String.Index) -> Character? {
        guard index < snapshot.characters.endIndex else { return nil }
        
        return snapshot.characters[index]
    }
    
    // MARK: Helpers: Subindex

    @inlinable func subindex(after subindex: Snapshot.Index) -> Snapshot.Index? {
        subindex < snapshot.endIndex ? snapshot.index(after: subindex) : nil
    }

    @inlinable func subindex(before subindex: Snapshot.Index) -> Snapshot.Index? {
        subindex > snapshot.startIndex ? snapshot.index(before: subindex) : nil
    }
    
    // MARK: Helpers: Subelement
    
    @inlinable func subelement(at index: Snapshot.Index?) -> Symbol? {
        guard let index = index, index < snapshot.endIndex else { return nil }; return snapshot[index]
    }

    // MARK: Components: Index
    
    @usableFromInline struct Index: Comparable {
        
        // MARK: Properties
        
        @usableFromInline let offset: Offset
        @usableFromInline let lhs: Snapshot.Index?
        @usableFromInline let rhs: Snapshot.Index?
        
        // MARK: Initialization

        @inlinable init(at position: Offset, lhs: Snapshot.Index, rhs: Snapshot.Index?) {
            self.offset = position
            self.lhs = lhs
            self.rhs = rhs
        }
        
        @inlinable init(at position: Offset, lhs: Snapshot.Index?, rhs: Snapshot.Index) {
            self.offset = position
            self.lhs = lhs
            self.rhs = rhs
        }
                
        // MARK: Comparable
        
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            guard let a = lhs.rhs else { return false }
            guard let b = rhs.rhs else { return  true }

            return a < b
        }
        
        // MARK: Equatable
        
        @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.rhs == rhs.rhs
        }
    }
}

// MARK: - Index

extension Carets {
    
    // MARK: Offset
    
    @inlinable func index(start: Index, offset: Offset) -> Index {
        offset.distance >= 0 ? index(start: start, forwards: offset) : index(start: start, backwards: offset)
    }
    
    @inlinable func index(start: Index, forwards offset: Offset) -> Index {
        assert(offset.distance >= 0)
        let destination = start.offset.distance + offset.distance
        return indices[start...].first(where: { index in index.offset.distance >= destination }) ?? endIndex
    }
    
    @inlinable func index(start: Index, backwards offset: Offset) -> Index {
        assert(offset.distance <= 0)
        let destination = start.offset.distance + offset.distance
        return indices[...start].last(where: { index in index.offset.distance <= destination }) ?? startIndex
    }
}
