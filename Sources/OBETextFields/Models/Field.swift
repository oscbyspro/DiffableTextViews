//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

#warning("Something about indices is probably wrong, also NonEmptyCollection.")

#warning("Field should contain Format and Selection, it is grouped because new format invalidates the Selection. Should be a struct.")

final class Field {
    let format: Format
    var selection: Selection
    
    // MARK: Getters
    
    @inlinable var symbols: Format {
        container.symbols
    }
    
    @inlinable var symbolsIndices: Format.Indices {
        container.symbolsIndices
    }
    
    @inlinable var carets: Carets {
        container.carets
    }
    
    @inlinable var caretsIndices: Carets.Indices {
        container.caretsIndices
    }
        
    // MARK: Initializers
            
    /// - Complexity: O(1).
    @inlinable init(_ symbols: Format = Format()) {
        let container = Container(symbols)
        let selection = Selection(container.caretsIndices.last)
        
        self.container = container
        self.selection = selection
    }
    
    // MARK: Components
    
    struct Container {
        let symbols: Format
        let symbolsIndices: Format.Indices
        
        let carets: Carets
        let caretsIndices: Carets.Indices
        
        // MARK: Initializers
        
        /// - Complexity: O(1).
        @inlinable init(_ symbols: Format) {
            self.symbols = symbols
            self.symbolsIndices = symbols.indices
            self.carets = symbols.carets
            self.caretsIndices = carets.indices
        }
    }
    
    struct Selection {
        #warning("Maybe define as: caretsIndice and offsets")
        
        var lowerBound: Carets.Index
        var upperBound: Carets.Index
            
        // MARK: Initializers
        
        /// - Complexity: O(1).
        @inlinable init(_ index: Carets.Index) {
            self.lowerBound = index
            self.upperBound = index
        }
        
        /// - Complexity: O(1).
        @inlinable init(_ indices: Carets.Indices) {
            self.lowerBound = indices.first
            self.upperBound = indices.last
        }
        
        /// - Complexity: O(1).
        @inlinable init(_ bounds: Range<Carets.Index>) {
            self.lowerBound = bounds.lowerBound
            self.upperBound = bounds.upperBound
        }
        
        // MARK: Utilities
        
        var offsets: Range<Int> {
            lowerBound.offset ..< upperBound.offset
        }
    }
}

// MARK: - Update: Carets

extension Field {
    /// - Complexity: O(min(n, m)) where n is the length of the current carets and m is the length of next.
    @inlinable func update(symbols newValue: Format) {
        let next = Container(newValue)
        
        func relevant(element: Caret) -> Bool {
            element.rhs.attribute == .content
        }
        
        func equality(lhs: Caret, rhs: Caret) -> Bool {
            lhs.rhs.character == rhs.rhs.character
        }
        
        func index(current: Carets.SubSequence, next: Carets.SubSequence) -> Carets.Index {
            next.suffix(alsoIn: current, options: .inspect(relevant, overshoot: true)).startIndex
        }
        
        let upperNext = next.carets[...]
        let upperCurrent = carets[selection.upperBound...]
        let upperBound = index(current: upperCurrent, next: upperNext)
         
        let lowerNext = next.carets[...upperBound]
        let lowerCurrent = carets[selection.lowerBound ..< selection.upperBound]
        let lowerBound = index(current: lowerCurrent, next: lowerNext)
        
        self.container = next
        self.selection = Selection(lowerBound ..< upperBound)
    }
}

// MARK: - Update: Selection

extension Field {
    /// - Complexity: O(k) where k is the length.in carets that consists of prefixes and suffixes.
    @inlinable func update(selection newValue: Selection) {
        var lowerBound = newValue.lowerBound
        var upperBound = newValue.upperBound
        
        moveInsideBounds(&lowerBound)
        moveInsideBounds(&upperBound)
        
        self.selection = Selection(lowerBound ..< upperBound)
    }
    
    // MARK: Helpers
    
    /// - Complexity: O(1).
    @inlinable func next(_ index: Carets.Index) -> Carets.Index? {
        index < caretsIndices.last ? caretsIndices.index(after: index) : nil
    }
    
    /// - Complexity: O(1).
    @inlinable func prev(_ index: Carets.Index) -> Carets.Index? {
        index > caretsIndices.first ? caretsIndices.index(before: index) : nil
    }
    
    /// - Complexity: O(n) where n is the number of elements in base.
    @usableFromInline func move(_ index: inout Carets.Index, step: (Carets.Index) -> Carets.Index?, while predicate: (Caret) -> Bool) {
        while predicate(carets[index]), let next = step(index) { index = next }
    }
    
    /// - Complexity: O(n) where n is the number of elements in base.
    @usableFromInline func moveInsideBounds(_ index: inout Carets.Index) {
        move(&index, step: next, while: { $0.rhs.attribute == .prefix })
        move(&index, step: prev, while: { $0.lhs.attribute == .suffix })
    }
}
