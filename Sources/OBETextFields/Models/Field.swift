//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

#warning("Something about indices is probably wrong, also NonEmptyCollection.")

final class Field {
    typealias Index = Carets.Index
    typealias Indices = Carets.Indices

    // MARK: Properties
    
    var container: Container
    var selection: Selection
    
    // MARK: Properties: Getters
    
    @inlinable var carets: Carets {
        container.carets
    }
    
    @inlinable var caretsIndices: Indices {
        container.caretsIndices
    }
    
    @inlinable var characters: String {
        container.carets.base.base.characters
    }
    
    // MARK: Initializers
            
    /// - Complexity: O(1).
    @inlinable init(_ carets: Carets, selection: Selection) {
        self.container = Container(carets)
        self.selection = selection
    }
    
    /// - Complexity: O(1).
    @inlinable convenience init(_ carets: Carets) {
        self.init(carets, selection: Selection(carets.indices.last))
    }
    
    // MARK: Components
    
    struct Container {
        #warning("Add symbols and symbolsIndoces, maybe?")
        
        let carets: Carets
        let caretsIndices: Indices
        
        // MARK: Initializers
        
        /// - Complexity: O(1).
        @inlinable init(_ carets: Carets) {
            self.carets = carets
            self.caretsIndices = carets.indices
        }
    }
    
    struct Selection {
        #warning("Maybe define as: caretsIndice and offsets")
        
        var lowerBound: Index
        var upperBound: Index
            
        // MARK: Initializers
        
        /// - Complexity: O(1).
        @inlinable init(_ index: Index) {
            self.lowerBound = index
            self.upperBound = index
        }
        
        /// - Complexity: O(1).
        @inlinable init(_ indices: Indices) {
            self.lowerBound = indices.first
            self.upperBound = indices.last
        }
        
        /// - Complexity: O(1).
        @inlinable init(_ bounds: Range<Index>) {
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
    @inlinable func update(carets newValue: Carets) {
        func relevant(element: Caret) -> Bool {
            element.rhs.attribute == .content
        }
        
        func equality(lhs: Caret, rhs: Caret) -> Bool {
            lhs.rhs.character == rhs.rhs.character
        }
        
        func index(current: Carets.SubSequence, next: Carets.SubSequence) -> Carets.Index {
            next.suffix(alsoIn: current, options: .inspect(relevant, overshoot: true)).startIndex
        }
        
        let upperNext = newValue[...]
        let upperCurrent = carets[selection.upperBound...]
        let upperBound = index(current: upperCurrent, next: upperNext)
         
        let lowerNext = newValue[...upperBound]
        let lowerCurrent = carets[selection.lowerBound ..< selection.upperBound]
        let lowerBound = index(current: lowerCurrent, next: lowerNext)
        
        self.container = Container(newValue)
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
    @inlinable func next(_ index: Index) -> Index? {
        index < caretsIndices.last ? caretsIndices.index(after: index) : nil
    }
    
    /// - Complexity: O(1).
    @inlinable func prev(_ index: Index) -> Index? {
        index > caretsIndices.first ? caretsIndices.index(before: index) : nil
    }
    
    /// - Complexity: O(n) where n is the number of elements in base.
    @usableFromInline func move(_ index: inout Index, step: (Index) -> Index?, while predicate: (Caret) -> Bool) {
        while predicate(carets[index]), let next = step(index) { index = next }
    }
    
    /// - Complexity: O(n) where n is the number of elements in base.
    @usableFromInline func moveInsideBounds(_ index: inout Index) {
        move(&index, step: next, while: { $0.rhs.attribute == .prefix })
        move(&index, step: prev, while: { $0.lhs.attribute == .suffix })
    }
}
