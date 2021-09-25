//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

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
    
    @inlinable var indices: Indices {
        container.indices
    }
    
    // MARK: Initializers
            
    /// - Complexity: O(1).
    @inlinable init(_ carets: Carets, selection: Selection) {
        self.container = Container(carets: carets)
        self.selection = selection
    }
    
    /// - Complexity: O(1).
    @inlinable convenience init(_ carets: Carets) {
        self.init(carets, selection: Selection(index: carets.indices.last))
    }
    
    // MARK: Components
    
    struct Container {
        let carets: Carets
        let indices: Indices
        
        // MARK: Initializers
        
        /// - Complexity: O(1).
        @inlinable init(carets: Carets) {
            self.carets = carets
            self.indices = carets.indices
        }
    }
    
    struct Selection {
        var lowerBound: Index
        var upperBound: Index
            
        // MARK: Initializers
        
        /// - Complexity: O(1).
        @inlinable init(index: Index) {
            self.lowerBound = index
            self.upperBound = index
        }
        
        /// - Complexity: O(1).
        @inlinable init(bounds: Range<Index>) {
            self.lowerBound = bounds.lowerBound
            self.upperBound = bounds.upperBound
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
        
        self.container = Container(carets: newValue)
        self.selection = Selection(bounds: lowerBound ..< upperBound)
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
        
        self.selection = Selection(bounds: lowerBound ..< upperBound)
    }
    
    // MARK: Helpers
    
    /// - Complexity: O(1).
    @inlinable func next(_ index: Index) -> Index? {
        index < indices.last ? indices.index(after: index) : nil
    }
    
    /// - Complexity: O(1).
    @inlinable func prev(_ index: Index) -> Index? {
        index > indices.first ? indices.index(before: index) : nil
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
