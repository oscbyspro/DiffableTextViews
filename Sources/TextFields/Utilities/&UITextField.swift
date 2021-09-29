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
    
    @inlinable func set(text content: String) {
        text = content
    }
}

extension UITextField {
    // MARK: Selection: Get
    
    @inlinable func selection() -> Range<Int>? {
        selectedTextRange.map(offsets)
    }
    
    // MARK: Selection: Set
        
    @inlinable func set(selection bounds: Range<Int>?) {
        selectedTextRange = bounds.map(range) ?? nil
    }
    
    @inlinable func changeSelection(offsets: (start: Int, end: Int)) {
        guard let selection = selectedTextRange else { return }
        let start = position(from: selection.start, offset: offsets.start)!
        let end = position(from: selection.end, offset: offsets.end)!
        
        selectedTextRange = textRange(from: start, to: end)!
    }
}

extension UITextField {
    // MARK: Positions

    @inlinable var start: UITextPosition {
        beginningOfDocument
    }
    
    @inlinable var end: UITextPosition {
        endOfDocument
    }
}

extension UITextField {
    // MARK: Ranges
    
    @inlinable func range(in offsets: Range<Int>) -> UITextRange? {
        guard let lowerBound = position(from: start, offset: offsets.lowerBound) else { return nil }
        guard let upperBound = position(from: lowerBound, offset: offsets.count) else { return nil }
        
        return textRange(from: lowerBound, to: upperBound)
    }
}

extension UITextField {
    // MARK: Offsets
    
    @inlinable func offsets(in range: UITextRange) -> Range<Int> {
        let start = offset(from: start, to: range.start)
        let count = offset(from: range.start, to: range.end)
        
        return start ..< (start + count)
    }
}

#endif
