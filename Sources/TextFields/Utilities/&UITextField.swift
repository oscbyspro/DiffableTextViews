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
    
    @inlinable func setText(_ text: String) {
        self.text = text
    }
}

extension UITextField {
    
    // MARK: Selection: Get
    
    @inlinable func selection() -> Range<Int>? {
        selectedTextRange.map(offsets)
    }
    
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
}

extension UITextField {
    // MARK: Ranges
    
    @inlinable func range(in offsets: Range<Int>) -> UITextRange {
        let start = position(from: beginningOfDocument, offset: offsets.lowerBound)!
        let end = position(from: start, offset: offsets.count)!
        
        return textRange(from: start, to: end)!
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
