//
//  SomeTextField.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

import UIKit

@usableFromInline final class Proxy {
    @usableFromInline typealias Position = TextFields.Position<UTF16>
    
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
    
    @inlinable func selection() -> Range<Position>? {
        uiTextField.selectedTextRange.map(positions(in:))
    }
    
    @inlinable func select(_ offsets: Range<Position>) {
        uiTextField.selectedTextRange = range(in: offsets)
    }
    
    @inlinable func select(changes: (start: Int, end: Int)) {
        guard let selection = uiTextField.selectedTextRange else { return }
        
        let start = uiTextField.position(from: selection.start, offset: changes.start)!
        let end   = uiTextField.position(from: selection.end,   offset: changes.end)!
        
        uiTextField.selectedTextRange = uiTextField.textRange(from: start, to: end)!
    }
    
    // MARK: Helpers: Positions

    @inlinable func positions(in bounds: UITextRange) -> Range<Position> {
        let start = uiTextField.offset(from: uiTextField.beginningOfDocument, to: bounds.start)
        let count = uiTextField.offset(from: bounds.start,                to: bounds.end)
        
        return Position(at: start) ..< Position(at: start + count)
    }

    @inlinable func range(in positions: Range<Position>) -> UITextRange {
        let start = uiTextField.position(from: uiTextField.beginningOfDocument, offset: positions.lowerBound.offset)!
        let end   = uiTextField.position(from: start, offset: positions.upperBound.offset - positions.lowerBound.offset)!
        
        return uiTextField.textRange(from: start, to: end)!
    }
}
