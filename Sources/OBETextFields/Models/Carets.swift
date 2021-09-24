//
//  Carets.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

@usableFromInline struct Carets: BidirectionalCollection {
    public typealias SubSequence = Slice<Self>

    // MARK: Properties
    
    @usableFromInline let symbols: Symbols.SubSequence

    // MARK: Initializers
    
    /// - Complexity: O(1).
    @inlinable init(_ symbols: Symbols = Symbols()) {
        self.symbols = symbols[...]
    }
    
    @inlinable init(_ symbols: Symbols.SubSequence) {
        self.symbols = symbols
    }
    
    // MARK: BidirectionalCollection
    
    /// - Complexity: O(1).
    @inlinable var startIndex: Caret {
        Index(lhs: nil, rhs: symbols.startIndex)
    }
    
    /// - Complexity: O(1).
    @inlinable var endIndex: Caret {
        Index(lhs: symbols.endIndex, rhs: nil)
    }

    /// - Complexity: O(1).
    @inlinable func index(after i: Caret) -> Caret {
        Index(lhs: i.rhs!, rhs: subindex(after: i.rhs!))
    }

    /// - Complexity: O(1).
    @inlinable func index(before i: Caret) -> Caret {
        Index(lhs: subindex(before: i.lhs!), rhs: i.lhs!)
    }

    /// - Complexity: O(1).
    @inlinable subscript(position: Caret) -> Caret {
        position
    }

    // MARK: Interoperabilities

    /// - Complexity: O(1).
    @usableFromInline func index(lhs: Symbols.Index) -> Caret {
        Index(lhs: lhs, rhs: subindex(after: lhs))
    }

    /// - Complexity: O(1).
    @usableFromInline func index(rhs: Symbols.Index) -> Caret {
        Index(lhs: subindex(before: rhs), rhs: rhs)
    }

    // MARK: Helpers

    /// - Complexity: O(1).
    @inlinable func subindex(after subindex: Symbols.Index) -> Symbols.Index? {
        guard subindex < symbols.endIndex else {
            return nil
        }

        return symbols.index(after: subindex)
    }

    /// - Complexity: O(1).
    @inlinable func subindex(before subindex: Symbols.Index) -> Symbols.Index? {
        guard subindex > symbols.startIndex else {
            return nil
        }

        return symbols.index(before: subindex)
    }
}

// MARK: - Nonempty

extension Carets {
    var first: Caret {
        self.first!
    }
    
    var last: Caret {
        self.last!
    }
    
    func min() -> Caret {
        self.first!
    }
    
    func max() -> Caret {
        self.last!
    }
}
