//
//  Proxy.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

import UIKit

@usableFromInline final class Proxy {
    @usableFromInline typealias Offset = TextFields.Offset<UTF16>
    
    // MARK: Properties
    
    @usableFromInline let uiTextField: UITextField
    
    // MARK: Initializers
    
    @inlinable init(_ uiTextField: UITextField) {
        self.uiTextField = uiTextField
    }
    
    // MARK: Getters
    
    @inlinable var edits: Bool {
        uiTextField.isEditing
    }
    
    // MARK: Text
    
    @inlinable var text: String {
        uiTextField.text!
    }
    
    @inlinable func write(_ text: String) {
        uiTextField.text = text
    }
    
    // MARK: Selection
    
    @inlinable func selection() -> Range<Offset>? {
        uiTextField.selectedTextRange.map(positions(in:))
    }
    
    @inlinable func select(_ offsets: Range<Offset>) {
        uiTextField.selectedTextRange = range(in: offsets)
    }
    
    @inlinable func select(changes: (start: Offset, end: Offset)) {
        guard let selection = uiTextField.selectedTextRange else { return }
        
        let start = uiTextField.position(from: selection.start, offset: changes.start.distance)!
        let end   = uiTextField.position(from: selection.end,   offset:   changes.end.distance)!
        
        uiTextField.selectedTextRange = uiTextField.textRange(from: start, to: end)!
    }
    
    // MARK: Helpers: Positions

    @inlinable func positions(in bounds: UITextRange) -> Range<Offset> {
        let start = uiTextField.offset(from: uiTextField.beginningOfDocument, to: bounds.start)
        let count = uiTextField.offset(from: bounds.start,                to: bounds.end)
        
        return Offset(at: start) ..< Offset(at: start + count)
    }

    @inlinable func range(in positions: Range<Offset>) -> UITextRange {
        let start = uiTextField.position(from: uiTextField.beginningOfDocument, offset: positions.lowerBound.distance)!
        let end   = uiTextField.position(from: start, offset: positions.upperBound.distance - positions.lowerBound.distance)!
        
        return uiTextField.textRange(from: start, to: end)!
    }
}
