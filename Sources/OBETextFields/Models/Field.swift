//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

import Foundation

struct Field {
    typealias Index = Carets.Index
    typealias Indices = Carets.Indices

    // MARK: Properties
    
    let carets: Carets
    let indices: Indices
    let selection: Selection
    
    // MARK: Initializers
            
    /// - Complexity: O(1).
    @inlinable init(_ carets: Carets, selection: Selection) {
        self.carets = carets
        self.selection = selection
        self.indices = carets.indices
    }
    
    /// - Complexity: O(1).
    @inlinable init(_ carets: Carets) {
        self.init(carets, selection: Selection(carets.indices.last))
    }
    
    // MARK: Components
    
    struct Selection {
        var lowerBound: Index
        var upperBound: Index
            
        @inlinable init(_ index: Index) {
            self.lowerBound = index
            self.upperBound = index
        }
        
        @inlinable init(_ range: Range<Index>) {
            self.lowerBound = range.lowerBound
            self.upperBound = range.upperBound
        }
    }
}

// MARK: - Update: Carets

extension Field {
    /// - Complexity: O(min(n, m)) where n is the length of the current carets and m is the length of next.
    @inlinable func updated(carets newValue: Carets) -> Self {
        func relevant(element: Caret) -> Bool {
            element.rhs.attribute == .content
        }
        
        func equality(lhs: Caret, rhs: Caret) -> Bool {
            lhs.rhs.character == rhs.rhs.character
        }
        
        func index(current: Carets.SubSequence, next: Carets.SubSequence) -> Carets.Index {
            next.suffix(suffixing: current, comparing: relevant, using: equality).startIndex
        }
        
        let upperNext = newValue[...]
        let upperCurrent = carets[selection.upperBound...]
        let upperBound = index(current: upperCurrent, next: upperNext)
         
        let lowerNext = newValue[...upperBound]
        let lowerCurrent = carets[selection.lowerBound ..< selection.upperBound]
        let lowerBound = index(current: lowerCurrent, next: lowerNext)
                
        return Self(newValue, selection: Selection(lowerBound ..< upperBound))
    }
}

// MARK: - Update: Selection

extension Field {
    /// - Complexity: O(k) where k is the length.in carets that consists of prefixes and suffixes.
    @inlinable func updated(selection newValue: Range<Carets.Index>) -> Self {
        var lowerBound = newValue.lowerBound
        var upperBound = newValue.upperBound
        
        moveInsideBounds(&lowerBound)
        moveInsideBounds(&upperBound)
        
        return Self(carets, selection: selection)
    }
    
    // MARK: Helpers
    
    /// - Complexity: O(1).
    @inlinable func next(_ index: Index) -> Index? {
        index < carets.indices.last ? carets.indices.index(after: index) : nil
    }
    
    /// - Complexity: O(1).
    @inlinable func prev(_ index: Index) -> Index? {
        index > carets.indices.first ? carets.indices.index(before: index) : nil
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
