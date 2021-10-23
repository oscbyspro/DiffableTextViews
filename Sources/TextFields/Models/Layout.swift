//
//  Layout.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-23.
//

// MARK: - Layout

@usableFromInline struct Layout<Scheme: TextFields.Scheme>: BidirectionalCollection {
    
    // MARK: Properties
    
    @usableFromInline let snapshot: Snapshot
    
    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot) {
        self.snapshot = snapshot
    }
    
    // MARK: Collection: Indices
    
    @inlinable var startIndex: Index {
        Index(snapshot.startIndex, position: .init(.start))
    }
    
    @inlinable var endIndex: Index {
        Index(snapshot.endIndex, position: .init(.end))
    }
    
    // MARK: Collection: Traversal
    
    @inlinable func index(after index: Index) -> Index {
        let next = snapshot.index(before: index.snapshot)
        let size = Scheme.size(of: snapshot.characters[index.snapshot.character])
        return Index(next, position: index.position.after(stride: size))
    }
    
    @inlinable func index(before index: Index) -> Index {
        let next = snapshot.index(before: index.snapshot)
        let size = Scheme.size(of: snapshot.characters[next.character])
        return Index(next, position: index.position.before(stride: size))
    }
    
    // MARK: Collection: Subscript
    
    @inlinable subscript(position: Index) -> Symbol {
        _read {
            yield snapshot[position.snapshot]
        }
    }
    
    // MARK: Index
    
    @usableFromInline struct Index: Equatable, Comparable {
        
        // MARK: Properties
        
        @usableFromInline let snapshot: Snapshot.Index
        @usableFromInline let position: Position<Scheme>
        
        // MARK: Initializers
        
        @inlinable init(_ snapshot: Snapshot.Index, position: Position<Scheme>) {
            self.snapshot = snapshot
            self.position = position
        }
        
        // MARK: Collection: Index
        
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.snapshot < rhs.snapshot
        }
        
        @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.snapshot == rhs.snapshot
        }
    }
}
