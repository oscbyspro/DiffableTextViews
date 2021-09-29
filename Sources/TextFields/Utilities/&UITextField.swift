//
//  &UITextField.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

#if canImport(UIKit)

import UIKit

extension UITextField {
    // MARK: Text: Set
    
    @inlinable func write(_ content: String) {
        text = content
    }
}

extension UITextField {
    // MARK: Selection: Get
    
    @inlinable func selection() -> Range<Int>? {
        selectedTextRange.map(offsets)
    }
    
    // MARK: Selection: Set
        
    @inlinable func select(offsets: Range<Int>?) {
        selectedTextRange = offsets.map(range) ?? nil
    }
    
    @inlinable func select(changes: (start: Int, end: Int)) {
        guard let selection = selectedTextRange else { return }
                
        let start = position(from: selection.start, offset: changes.start)!
        let end = position(from: selection.end, offset: changes.end)!
        
        selectedTextRange = textRange(from: start, to: end)!
    }
}

extension UITextField {
    // MARK: Ranges
    
    @inlinable func range(in offsets: Range<Int>) -> UITextRange? {
        guard let start = position(from: beginningOfDocument, offset: offsets.lowerBound) else { return nil }
        guard let end = position(from: start, offset: offsets.count) else { return nil }
        
        return textRange(from: start, to: end)
    }
}

extension UITextField {
    // MARK: Offsets
    
    @inlinable func offsets(in range: UITextRange) -> Range<Int> {
        let start = offset(from: beginningOfDocument, to: range.start)
        let count = offset(from: range.start, to: range.end)
        
        return start ..< (start + count)
    }
}

#endif
