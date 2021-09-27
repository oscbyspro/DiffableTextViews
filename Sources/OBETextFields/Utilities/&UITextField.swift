//
//  &UITextField.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

import SwiftUI

extension UITextField {
    // MARK: Text
    
    @inlinable func set(text content: String) {
        text = content
    }
    
    // MARK: Selection
    
    @inlinable func selection() -> Range<Int>? {
        selectedTextRange.map(offsets)
    }
    
    @inlinable func set(selection bounds: Range<Int>?) {
        selectedTextRange = bounds.map(range) ?? nil
    }
    
    // MARK: Positions

    @inlinable var start: UITextPosition {
        beginningOfDocument
    }
    
    @inlinable var end: UITextPosition {
        endOfDocument
    }
        
    @inlinable func position(at offset: Int) -> UITextPosition? {
        position(from: start, offset: offset)
    }
    
    @inlinable func position(offsetting other: UITextPosition, by amount: Int) -> UITextPosition? {
        position(from: other, offset: amount)
    }
    
    @inlinable func position(closestTo position: UITextPosition, in range: UITextRange) -> UITextPosition {
        max(range.start, min(position, range.end))
    }
    
    // MARK: Comparison

    @inlinable func min(_ lhs: UITextPosition, _ rhs: UITextPosition) -> UITextPosition {
        compare(lhs, to: rhs) == .orderedAscending ? lhs : rhs
    }
    
    @inlinable func max(_ lhs: UITextPosition, _ rhs: UITextPosition) -> UITextPosition {
        compare(lhs, to: rhs) == .orderedAscending ? rhs : lhs
    }
    
    // MARK: Range
    
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
    
    @inlinable func offsets(in range: UITextRange) -> Range<Int> {
        let start: Int = offset(from: start, to: range.start)
        let count: Int = offset(from: range.start, to: range.end)
        
        return start ..< start + count
    }
}
