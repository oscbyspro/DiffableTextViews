//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

struct Field {
    let carets: Carets
    let selection: Range<Carets.Index>
    
    // MARK: Initializers
    
    /// - Complexity: O(1).
    @inlinable init(_ carets: Carets) {
        let index = carets.indices.last
        self.init(carets, selection: index ..< index)
    }
        
    /// - Complexity: O(1).
    @inlinable init(_ carets: Carets, selection: Range<Carets.Index>) {
        self.carets = carets
        self.selection = selection
    }
    
    // MARK: Transformations
    
    #warning("Updating selection method needs a rework.")
    #warning("Should calculate correct selection based on attributes, and previous selection.")
    /// - Complexity: O(1).
    @inlinable func updated(selection newValue: Range<Carets.Index>) -> Self {
        Self(carets, selection: selection)
    }
    
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
        let lowerCurrent = carets[selection]
        let lowerBound = index(current: lowerCurrent, next: lowerNext)
        
        return Self(newValue, selection: lowerBound ..< upperBound)
    }
}
