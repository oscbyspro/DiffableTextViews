//
//  &UITextField.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

#if canImport(UIKit)

import UIKit

// MARK: - UITextField

extension UITextField {
    
    // MARK: Text: Set
    
    @inlinable func setText(_ text: String) {
        self.text = text
    }
}

extension UITextField {
    
    // MARK: Selection: Set
        
    @inlinable func setSelection(_ offsets: Range<Int>?) {
        self.selectedTextRange = offsets.map(range)
    }
    
    @inlinable func setSelection(changes: (start: Int, end: Int)) {
        guard let selection = selectedTextRange else { return }
        
        let start = position(from: selection.start, offset: changes.start)!
        let end = position(from: selection.end, offset: changes.end)!
        
        self.selectedTextRange = textRange(from: start, to: end)!
    }
    
    // MARK: Selection: Set, Helpers

    @inlinable func range(in offsets: Range<Int>) -> UITextRange {
        let start = position(from: beginningOfDocument, offset: offsets.lowerBound)!
        let end = position(from: start, offset: offsets.count)!
        
        return textRange(from: start, to: end)!
    }
}

extension UITextField {
    
    // MARK: Selection: Get
    
    @inlinable func selection() -> Range<Int>? {
        selectedTextRange.map(offsets)
    }
    
    // MARK: Selection: Get, Helpers

    #warning("offsetsFromStart, make offsetsFromEnd also.")
    @inlinable func offsets(in bounds: UITextRange) -> Range<Int> {
        let start = offset(from: beginningOfDocument, to: bounds.start)
        let count = offset(from: bounds.start,        to: bounds.end)
        
        return start ..< (start + count)
    }
}


#warning("WIP")

extension UITextField {
    @usableFromInline typealias Position = TextFields.Position<UTF16>
    
    /// - Complexity: O(1).
    @inlinable func first() -> Position {
        .init(at: .zero)
    }
    
    /// - Complexity: Unknown, either O(n) or O(1).
    @inlinable func last() -> Position {
        .init(at: offset(from: beginningOfDocument, to: endOfDocument))
    }
    
    /// - Complexity: Unknown, either O(n) or O(1).
    @inlinable func position(at uiTextPosition: UITextPosition) -> Position {
        .init(at: offset(from: beginningOfDocument, to: uiTextPosition))
    }
}

#endif
