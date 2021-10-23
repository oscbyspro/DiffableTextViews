//
//  Layout.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-23.
//

// MARK: - Layout

@usableFromInline struct Layout<Scheme: LayoutScheme> {
    
    // MARK: Properties
    
    @usableFromInline let snapshot: Snapshot
    
    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot) {
        self.snapshot = snapshot
    }
    
    // MARK: Collection: Indices
    
    @inlinable var startIndex: Index {
        Index(snapshot.startIndex)
    }
    
    @inlinable var endIndex: Index {
        Index(snapshot.endIndex)
    }
    
    // MARK: Collection: Traversal
    
    @inlinable func index(after i: Index) -> Index {
        let next = snapshot.index(before: i.snapshot)
        let size = Scheme.size(of: snapshot.characters[i.snapshot.character])
        return Index(next, i.position + size)
    }
    
    @inlinable func index(before i: Index) -> Index {
        let next = snapshot.index(before: i.snapshot)
        let size = Scheme.size(of: snapshot.characters[next.character])
        return Index(next, i.position - size)
    }
    
    // MARK: Collection: Subscript
    
    @inlinable subscript(position: Index) -> Symbol {
        _read {
            yield snapshot[position.snapshot]
        }
    }
    
    // MARK: Index
    
    @usableFromInline struct Index: Comparable {
        
        // MARK: Properties
        
        #warning("Position should be a special type so it does not get confused")
        @usableFromInline let snapshot: Snapshot.Index
        @usableFromInline let position: Int
        
        // MARK: Initializers
        
        @inlinable init(_ snapshot: Snapshot.Index, _ position: Int = 0) {
            self.snapshot = snapshot
            self.position = position
        }
        
        // MARK: Comparable
        
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.snapshot < rhs.snapshot
        }
    }
}

// MARK: - LayoutScheme

@usableFromInline protocol LayoutScheme {
    static func size(of character: Character) -> Int
}

extension Character {
    @inlinable static func size(of character: Character) -> Int { 1 }
}

extension UTF8: LayoutScheme {
    @inlinable static func size(of character: Character) -> Int { character.utf8.count }
}

extension UTF16: LayoutScheme {
    @inlinable static func size(of character: Character) -> Int { character.utf16.count }
}
