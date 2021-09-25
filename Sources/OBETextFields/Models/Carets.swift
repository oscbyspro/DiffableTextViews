//
//  Carets.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

@usableFromInline struct Carets: BidirectionalCollection, NonemptyCollection {
    public typealias SubSequence = Slice<Self>
    public typealias Indices = DefaultIndices<Self>

    // MARK: Properties
    
    @usableFromInline let symbols: Symbols.SubSequence

    // MARK: Initializers
    
    /// - Complexity: O(1).
    @inlinable init(_ symbols: Symbols) {
        self.symbols = symbols[...]
    }
    
    @inlinable init(_ symbols: Symbols.SubSequence) {
        self.symbols = symbols
    }
    
    // MARK: BidirectionalCollection
    
    /// - Complexity: O(1).
    @inlinable var startIndex: Index {
        Index(lhs: nil, rhs: symbols.startIndex)
    }
    
    /// - Complexity: O(1).
    @inlinable var endIndex: Index {
        Index(lhs: symbols.endIndex, rhs: nil)
    }

    /// - Complexity: O(1).
    @inlinable func index(after i: Index) -> Index {
        Index(lhs: i.rhs!, rhs: symbolsIndex(after: i.rhs!))
    }

    /// - Complexity: O(1).
    @inlinable func index(before i: Index) -> Index {
        Index(lhs: symbolsIndex(before: i.lhs!), rhs: i.lhs!)
    }

    /// - Complexity: O(1).
    @inlinable subscript(position: Index) -> Caret {
        _read {
            yield Caret(lhs: symbol(at: position.lhs), rhs: symbol(at: position.rhs))
        }
    }

    // MARK: Interoperabilities

    /// - Complexity: O(1).
    @usableFromInline func index(lhs: Symbols.Index) -> Index {
        Index(lhs: lhs, rhs: symbolsIndex(after: lhs))
    }

    /// - Complexity: O(1).
    @usableFromInline func index(rhs: Symbols.Index) -> Index {
        Index(lhs: symbolsIndex(before: rhs), rhs: rhs)
    }

    // MARK: Helpers: Symbols.Index

    /// - Complexity: O(1).
    @inlinable func symbolsIndex(after symbolsIndex: Symbols.Index) -> Symbols.Index? {
        symbolsIndex < symbols.endIndex ? symbols.index(after: symbolsIndex) : nil
    }

    /// - Complexity: O(1).
    @inlinable func symbolsIndex(before symbolsIndex: Symbols.Index) -> Symbols.Index? {
        symbolsIndex > symbols.startIndex ? symbols.index(before: symbolsIndex) : nil
    }
    
    // MARK: Helpers: Symbols.Element
    
    @inlinable func symbol(at symbolsIndex: Symbols.Index?) -> Symbols.Element? {
        guard let symbolsIndex = symbolsIndex, symbolsIndex < symbols.endIndex else {
            return nil
        }

        return symbols[symbolsIndex]
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
