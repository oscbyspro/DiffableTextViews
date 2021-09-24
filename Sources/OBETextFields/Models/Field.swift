//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

struct Field {
    let positions: Positions
    let selection: Range<Positions.Index>
    
    // MARK: Initializers
    
    /// - Complexity: O(1).
    @inlinable init(_ positions: Positions = Positions()) {
        self.positions = positions
        self.selection = positions.endIndex ..< positions.endIndex
    }
    
    /// - Complexity: O(1).
    @inlinable init(_ positions: Positions, selection: Range<Positions.Index>) {
        self.positions = positions
        self.selection = selection
    }
    
    // MARK: Utilities
    
    /// - Complexity: O(1).
    @inlinable var offsets: Range<Int> {
        return selection.lowerBound.offset ..< selection.upperBound.offset
    }
    
    // MARK: Movements
    
    /// - Complexity: O(1).
    @inlinable func updated(selection newValue: Range<Format.Index>) -> Self {
        let lowerBound = positions.index(end: newValue.lowerBound)
        let upperBound = positions.index(end: newValue.upperBound)
        
        return Self(positions, selection: lowerBound ..< upperBound)
    }
    
    /// - Complexity: O(min(n, m)) where n is the length of the current carets and m is the length of next.
    @inlinable func updated(positions newValue: Positions) -> Self {
        func relevant(element: Positions.Element) -> Bool {
            element.end.attribute == .content
        }
        
        func comparison(lhs: Positions.Element, rhs: Positions.Element) -> Bool {
            lhs.end.character == rhs.end.character
        }
        
        let upperBound: Positions.Index = newValue
            .suffix(suffixing: positions.suffix(from: selection.upperBound), comparing: relevant, using: comparison)
            .startIndex
        
        let lowerBound: Positions.Index = newValue.prefix(upTo: upperBound)
            .suffix(suffixing: positions[selection], comparing: relevant, using: comparison)
            .startIndex
        
        return Self(newValue, selection: lowerBound ..< upperBound)
    }
}

