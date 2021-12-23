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
    
    /// - Complexity: O(n).
    @inlinable init(snapshot: Snapshot) {
        self.snapshot = snapshot
        self.range = .zero ..< .max(in: snapshot.characters)
    }
    
    // MARK: Positions
    
    @inlinable var startIndex: Index {
        Index(at: range.lowerBound, lhs: nil, rhs: snapshot.startIndex)
    }
    
    @inlinable var endIndex: Index {
        Index(at: range.upperBound, lhs: snapshot.endIndex, rhs: nil)
    }
    
    // MARK: Traverse
    
    @inlinable func index(after i: Index) -> Index {
        Index(at: i.offset.after(character(at: i.rhs!.character)), lhs: i.rhs!, rhs: subindex(after: i.rhs!))
    }
    
    @inlinable func index(before i: Index) -> Index {
        Index(at: i.offset.before(character(at: i.lhs!.character)), lhs: subindex(before: i.lhs!), rhs: i.lhs!)
    }
    
    /// - Complexity: O(n).
    @inlinable func index(at destination: Offset, start: Index) -> Index {
        if start.offset <= destination {
            return indices[start...].first(where: { $0.offset == destination })!
        } else {
            return indices[...start].last(where:  { $0.offset == destination })!
        }
    }
    
    // MARK: Traverse: Helpers
    
    @inlinable func character(at index: String.Index) -> Character? {
        index < snapshot.characters.endIndex ? snapshot.characters[index] : nil
    }

    // MARK: Subscripts
    
    @inlinable subscript(position: Index) -> Peek {
        .init(lhs: subelement(at: position.lhs), rhs: subelement(at: position.rhs))
    }
    
    // MARK: Subscripts: Helpers

    @inlinable func subindex(after subindex: Snapshot.Index) -> Snapshot.Index? {
        subindex < snapshot.endIndex ? snapshot.index(after: subindex) : nil
    }

    @inlinable func subindex(before subindex: Snapshot.Index) -> Snapshot.Index? {
        subindex > snapshot.startIndex ? snapshot.index(before: subindex) : nil
    }
        
    @inlinable func subelement(at index: Snapshot.Index?) -> Symbol? {
        guard let index = index, index < snapshot.endIndex else { return nil }; return snapshot[index]
    }
    
    // MARK: Index
    
    @usableFromInline struct Index: Comparable {
        
        // MARK: Properties
        
        @usableFromInline let offset: Offset
        @usableFromInline let lhs: Snapshot.Index?
        @usableFromInline let rhs: Snapshot.Index?
        
        // MARK: Initializers

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
        
        // MARK: Equations
        
        @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.rhs == rhs.rhs
        }
        
        // MARK: Comparisons
        
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            guard let a = lhs.rhs else { return false }
            guard let b = rhs.rhs else { return  true }
            return a < b
        }
    }
}
