//
//  Carets.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-04.
//

// MARK: - Carets

@usableFromInline struct Carets<Layout: TextFields.Layout>: BidirectionalCollection {
    @usableFromInline typealias Position = TextFields.Position<Layout>
    
    // MARK: Properties
    
    @usableFromInline let snapshot: Snapshot
    @usableFromInline let range: Range<Position>

    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot, last: Position) {
        self.snapshot = snapshot
        self.range = Position() ..< Position(at: last.offset)
    }
    
    @inlinable init(_ snapshot: Snapshot) {
        print(1)
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
        Index(at: i.position.after(character(at: i.rhs!.character)), lhs: i.rhs!, rhs: subindex(after: i.rhs!))
    }
    
    @inlinable func index(before i: Index) -> Index {
        Index(at: i.position.before(character(at: i.lhs!.character)), lhs: subindex(before: i.lhs!), rhs: i.lhs!)
    }
    
    // MARK: Collection: Subscripts
    
    @inlinable subscript(position: Index) -> Element {
        _read {
            yield Element(lhs: lhsSymbol(at: position.lhs), rhs: rhsSymbol(at: position.rhs))
        }
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
        
        // MARK: Utilities
        
        @inlinable var offset: Int {
            position.offset
        }
                
        // MARK: Collection: Index
                
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            guard let a = lhs.rhs else { return false }
            guard let b = rhs.rhs else { return  true }

            return a < b
        }
        
        @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.rhs == rhs.rhs
        }
    }
}

// MARK: - Is Never Empty

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

// MARK: - Position

extension Carets {
    
    @inlinable func index(_ start: Index, offsetBy stride: Position) -> Index {
        let destination = start.position.offset + stride.offset
        
        if stride.offset >= 0 {
            return indices[start...].first(where: { $0.offset >= destination }) ?? endIndex
        } else {
            return indices[...start].reversed().first(where: { $0.offset <= destination }) ?? startIndex
        }
    }
    
}
