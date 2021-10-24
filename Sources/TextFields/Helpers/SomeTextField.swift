//
//  SomeTextField.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

import UIKit

@usableFromInline final class SomeTextField {
    @usableFromInline typealias  Wrapped = UITextField
    @usableFromInline typealias Position = TextFields.Position<UTF16>
    
    // MARK: Properties
    
    @usableFromInline let wrapped: Wrapped
    
    // MARK: Initializers
    
    @inlinable init(_ wrapped: Wrapped) {
        self.wrapped = wrapped
    }
    
    // MARK: Getters
    
    @inlinable var edits: Bool {
        wrapped.isEditing
    }
    
    // MARK: Text
    
    @inlinable var text: String {
        wrapped.text!
    }
    
    @inlinable func write(_ text: String) {
        wrapped.text = text
    }
    
    // MARK: Selection
    
    @inlinable func selection() -> Range<Position>? {
        wrapped.selectedTextRange.map(positions(in:))
    }
    
    @inlinable func select(_ offsets: Range<Position>) {
        wrapped.selectedTextRange = range(in: offsets)
    }
    
    @inlinable func select(changes: (start: Int, end: Int)) {
        guard let selection = wrapped.selectedTextRange else { return }
        
        let start = wrapped.position(from: selection.start, offset: changes.start)!
        let end   = wrapped.position(from: selection.end,   offset: changes.end)!
        
        wrapped.selectedTextRange = wrapped.textRange(from: start, to: end)!
    }
    
    // MARK: Helpers: Positions

    @inlinable func positions(in bounds: UITextRange) -> Range<Position> {
        let start = wrapped.offset(from: wrapped.beginningOfDocument, to: bounds.start)
        let count = wrapped.offset(from: bounds.start,                to: bounds.end)
        
        return Position(at: start) ..< Position(at: start + count)
    }

    @inlinable func range(in positions: Range<Position>) -> UITextRange {
        let start = wrapped.position(from: wrapped.beginningOfDocument, offset: positions.lowerBound.offset)!
        let end   = wrapped.position(from: start, offset: positions.upperBound.offset - positions.lowerBound.offset)!
        
        return wrapped.textRange(from: start, to: end)!
    }
}
