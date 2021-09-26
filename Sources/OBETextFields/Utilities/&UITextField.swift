//
//  &UITextField.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

import SwiftUI

#warning("Add a method that moves selection based on change in offsets.")

extension UITextField {
    // MARK: Text
    
    /// - Complexity: O(1).
    @inlinable func set(text content: String) {
        text = content
    }
    
    // MARK: Selection
    
    /// - Complexity: O(k) where k is the maximum distance to selection.
    @inlinable func selection() -> Range<Int>? {
        selectedTextRange.map(offsets)
    }
    
    /// - Complexity: O(k) where k is the maximum absolute value of bounds.
    @inlinable func set(selection bounds: Range<Int>?) {
        selectedTextRange = bounds.map(range) ?? nil
    }
    
    // MARK: Positions

    /// - Complexity: O(1).
    @inlinable var start: UITextPosition {
        beginningOfDocument
    }
    
    /// - Complexity: O(1).
    @inlinable var end: UITextPosition {
        endOfDocument
    }
        
    /// - Complexity: O(k) where k is the absolute value of offset.
    @inlinable func position(at offset: Int) -> UITextPosition? {
        position(from: start, offset: offset)
    }
    
    /// - Complexity: O(k) where k is the absolute value of amount.
    @inlinable func position(offsetting other: UITextPosition, by amount: Int) -> UITextPosition? {
        position(from: other, offset: amount)
    }
    
    /// - Complexity: O(1).
    @inlinable func position(closestTo position: UITextPosition, in range: UITextRange) -> UITextPosition {
        max(range.start, min(position, range.end))
    }
    
    // MARK: Comparison

    /// - Complexity: O(1).
    @inlinable func min(_ lhs: UITextPosition, _ rhs: UITextPosition) -> UITextPosition {
        compare(lhs, to: rhs) == .orderedAscending ? lhs : rhs
    }
    
    /// - Complexity: O(1).
    @inlinable func max(_ lhs: UITextPosition, _ rhs: UITextPosition) -> UITextPosition {
        compare(lhs, to: rhs) == .orderedAscending ? rhs : lhs
    }
    
    // MARK: Range
    
    /// - Complexity: O(k) where k is the maximum absolute value of offsets.
    @inlinable func range(in offsets: Range<Int>) -> UITextRange? {
        guard let lowerBound: UITextPosition = position(from: start, offset: offsets.lowerBound) else {
            return nil
        }
                
        guard let upperBound: UITextPosition = position(from: lowerBound, offset: offsets.count) else {
            return nil
        }
        
        return textRange(from: lowerBound, to: upperBound)
    }
    
    // MARK: Offsets
    
    /// - Complexity: O(k) where k is the maximum absolute value of range.
    @inlinable func offsets(in range: UITextRange) -> Range<Int> {
        let start: Int = offset(from: start, to: range.start)
        let count: Int = offset(from: range.start, to: range.end)
        
        return start ..< start + count
    }
}
