//
//  Carets.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

@usableFromInline struct Carets: BidirectionalCollection, Nonempty {
    public typealias Indices = DefaultIndices<Self>
    public typealias SubSequence = Slice<Self>

    // MARK: Properties
    
    @usableFromInline let base: Symbols.SubSequence
    
    // MARK: Initializers
    
    /// - Complexity: O(1).
    @inlinable init(_ base: Symbols) {
        self.base = base[...]
    }
    
    @inlinable init(_ base: Symbols.SubSequence) {
        self.base = base
    }
    
    // MARK: BidirectionalCollection
    
    /// - Complexity: O(1).
    @inlinable var startIndex: Index {
        Index(lhs: nil, rhs: base.startIndex)
    }
    
    /// - Complexity: O(1).
    @inlinable var endIndex: Index {
        Index(lhs: base.endIndex, rhs: nil)
    }

    /// - Complexity: O(1).
    @inlinable func index(after i: Index) -> Index {
        Index(lhs: i.rhs!, rhs: baseIndex(after: i.rhs!))
    }

    /// - Complexity: O(1).
    @inlinable func index(before i: Index) -> Index {
        Index(lhs: baseIndex(before: i.lhs!), rhs: i.lhs!)
    }

    /// - Complexity: O(1).
    @inlinable subscript(position: Index) -> Caret {
        _read {
            yield Caret(lhs: baseElement(at: position.lhs), rhs: baseElement(at: position.rhs))
        }
    }

    // MARK: Interoperabilities

    /// - Complexity: O(1).
    @usableFromInline func index(lhs: Symbols.Index) -> Index {
        Index(lhs: lhs, rhs: baseIndex(after: lhs))
    }

    /// - Complexity: O(1).
    @usableFromInline func index(rhs: Symbols.Index) -> Index {
        Index(lhs: baseIndex(before: rhs), rhs: rhs)
    }

    // MARK: Helpers: Symbols.Index

    /// - Complexity: O(1).
    @inlinable func baseIndex(after baseIndex: Symbols.Index) -> Symbols.Index? {
        baseIndex < base.endIndex ? base.index(after: baseIndex) : nil
    }

    /// - Complexity: O(1).
    @inlinable func baseIndex(before baseIndex: Symbols.Index) -> Symbols.Index? {
        baseIndex > base.startIndex ? base.index(before: baseIndex) : nil
    }
    
    // MARK: Helpers: Symbols.Element
    
    @inlinable func baseElement(at baseIndex: Symbols.Index?) -> Symbols.Element? {
        guard let symbolsIndex = baseIndex, symbolsIndex < base.endIndex else {
            return nil
        }

        return base[symbolsIndex]
    }
    
    // MARK: Components
    
    @usableFromInline struct Index: Comparable {
        @usableFromInline let lhs: Symbols.Index?
        @usableFromInline let rhs: Symbols.Index?
            
        // MARK: Initializers
        
        @inlinable init(lhs: Symbols.Index, rhs: Symbols.Index?) {
            self.lhs = lhs
            self.rhs = rhs
        }
        
        @inlinable init(lhs: Symbols.Index?, rhs: Symbols.Index) {
            self.lhs = lhs
            self.rhs = rhs
        }
        
        // MARK: Utilities
        
        @inlinable var offset: Int {
            lhs.map({ $0.offset + 1 }) ?? 0
        }
        
        // MARK: Comparable
        
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.offset < rhs.offset
        }
    }
}

// MARK: - Symbols

extension Symbols {
    @inlinable var carets: Carets {
        Carets(self)
    }
}

extension Symbols.SubSequence {
    @inlinable var carets: Carets {
        Carets(self)
    }
}
