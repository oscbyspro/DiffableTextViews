//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

struct Field {
    let symbols: Symbols
    let selection: Range<Caret>
    
    // MARK: Initializers
    
    /// - Complexity: O(1).
    @inlinable init(_ symbols: Symbols = Symbols()) {
        self.symbols = symbols
        let last = symbols.carets.last
        self.selection = last ..< last
    }
    
    /// - Complexity: O(1).
    @inlinable init(_ symbols: Symbols, selection: Range<Caret>) {
        self.symbols = symbols
        self.selection = selection
    }
    
    // MARK: Transformations
    
    /// - Complexity: O(1).
    @inlinable func updated(selection newValue: Range<Caret>) -> Self {
        Self(symbols, selection: selection)
    }
    
    /// - Complexity: O(min(n, m)) where n is the length of the current carets and m is the length of next.
    @inlinable func updated(symbols newValue: Symbols) -> Self {
        func relevant(element: Pair) -> Bool {
            element.rhs?.attribute == .content
        }
        
        func equality(lhs: Pair, rhs: Pair) -> Bool {
            lhs.rhs?.character == rhs.rhs?.character
        }
        
        func caret(current: Pairs.SubSequence, next: Pairs.SubSequence) -> Caret {
            next.suffix(suffixing: current, comparing: relevant, using: equality).startIndex
        }
        
        let upperNext = newValue.pairs[...]
        let upperCurrent = symbols.pairs[selection.upperBound...]
        let upperBound = caret(current: upperCurrent, next: upperNext)
         
        let lowerNext = newValue.pairs[...upperBound]
        let lowerCurrent = symbols.pairs[selection]
        let lowerBound = caret(current: lowerCurrent, next: lowerNext)
        
        return Self(newValue, selection: lowerBound ..< upperBound)
    }
}
