//
//  Carets.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-04.
//

// MARK: - Carets

#warning("Count optimizations were removed, remember to check whether they are still called.")
@usableFromInline struct Carets<Layout: TextFields.Layout>: BidirectionalCollection {
    @usableFromInline typealias Position = TextFields.Position<Layout>
    
    // MARK: Properties
    
    @usableFromInline let snapshot: Snapshot
    @usableFromInline let range: Range<Position>

    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot, last: Position) {
        self.snapshot = snapshot
        self.range = Position(at: 0) ..< Position(at: last.offset + 1)
    }
    
    @inlinable init(_ snapshot: Snapshot) {
        self.init(snapshot, last: Position(at: Layout.size(of: snapshot.characters)))
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
        Index(at: i.position.after(snapshot.characters[i.rhs!.character]), lhs: i.rhs!, rhs: subindex(after: i.rhs!))
    }
    
    @inlinable func index(before i: Index) -> Index {
        Index(at: i.position.before(snapshot.characters[i.lhs!.character]), lhs: subindex(before: i.lhs!), rhs: i.lhs!)
    }
    
    // MARK: Collection: Subscripts
    
    @inlinable subscript(position: Index) -> Element {
        _read {
            yield Element(lhs: lhsSymbol(at: position.lhs), rhs: rhsSymbol(at: position.rhs))
        }
    }
    
    // MARK: Helpers: Subindex

    @inlinable func subindex(after subindex: Snapshot.Index) -> Snapshot.Index? {
        subindex < snapshot.endIndex ? snapshot.index(after: subindex) : nil
    }

    @inlinable func subindex(before subindex: Snapshot.Index) -> Snapshot.Index? {
        subindex > snapshot.startIndex ? snapshot.index(before: subindex) : nil
    }
    
    // MARK: Helpers: Subelement
    
    @inlinable func lhsSymbol(at index: Snapshot.Index?) -> Symbol? {
        guard let index = index else { return nil }; return snapshot[index]
    }
    
    @inlinable func rhsSymbol(at index: Snapshot.Index?) -> Symbol? {
        guard let index = index, index < snapshot.endIndex else { return nil }; return snapshot[index]
    }
    
    // MARK: Components
    
    @usableFromInline struct Element {
        
        // MARK: Properties
        
        @usableFromInline let lhs: Symbol
        @usableFromInline let rhs: Symbol
        
        // MARK: Initialization

        @inlinable init(lhs: Symbol?, rhs: Symbol?) {
            self.lhs = lhs ?? .prefix("\0")
            self.rhs = rhs ?? .suffix("\0")
        }
    }
    
    @usableFromInline struct Index: Comparable {
        
        // MARK: Properties
        
        @usableFromInline let position: Position
        @usableFromInline let lhs: Snapshot.Index?
        @usableFromInline let rhs: Snapshot.Index?
        
        // MARK: Initialization

        @inlinable init(at position: Position, lhs: Snapshot.Index, rhs: Snapshot.Index?) {
            self.position = position
            self.lhs = lhs
            self.rhs = rhs
        }
        
        @inlinable init(at position: Position, lhs: Snapshot.Index?, rhs: Snapshot.Index) {
            self.position = position
            self.lhs = lhs
            self.rhs = rhs
        }
                
        // MARK: Collection: Index
                
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            guard let a = lhs.rhs else { return false }
            guard let b = rhs.rhs else { return  true }
            
            return a < b
        }
        
        @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.lhs == rhs.lhs && lhs.rhs == rhs.rhs
        }
    }
}

// MARK: - Collection: Nonempty

extension Carets {
    
    // MARK: Element
    
    @inlinable var first: Element {
        first!
    }
    
    @inlinable var last: Element {
        last!
    }
    
    // MARK: Index
    
    @inlinable var firstIndex: Index {
        startIndex
    }
    
    @inlinable var lastIndex: Index {
        index(before: endIndex)
    }
}
