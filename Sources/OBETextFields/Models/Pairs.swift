//
//  Pairs.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

#warning("!!!")

@usableFromInline struct Pairs: BidirectionalCollection {
    public typealias SubSequence = Slice<Self>

    // MARK: Properties
    
    @usableFromInline let symbols: Symbols.SubSequence
    @usableFromInline let indices: Carets.SubSequence
    
    // MARK: Initializers
    
    @inlinable init(_ symbols: Symbols) {
        self.init(symbols[...])
    }
    
    @inlinable init(_ symbols: Symbols.SubSequence) {
        self.symbols = symbols
        self.indices = symbols.carets[...]
    }
    
    // MARK: BidirectionalCollection
    
    @inlinable var startIndex: Caret {
        indices.startIndex
    }
    
    @inlinable var endIndex: Caret {
        indices.endIndex
    }
    
    @inlinable func index(after i: Caret) -> Caret {
        indices.index(after: i)
    }
    
    @inlinable func index(before i: Caret) -> Caret {
        indices.index(before: i)
    }
    
    @inlinable subscript(position: Caret) -> Pair {
        _read {
            yield Pair(lhs: symbol(at: position.lhs), rhs: symbol(at: position.rhs))
        }
    }
    
    // MARK: Helpers
    
    @inlinable func symbol(at subindex: Symbols.Index?) -> Symbol? {
        guard let subindex = subindex, subindex < symbols.endIndex else {
             return nil
        }

        return symbols[subindex]
    }
}

// MARK: - Symbols

extension Symbols {
    @inlinable var pairs: Pairs {
        Pairs(self)
    }
}

extension Symbols.SubSequence {
    @inlinable var pairs: Pairs {
        Pairs(self)
    }
}
