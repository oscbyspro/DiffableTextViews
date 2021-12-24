//
//  ProxyTextField.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

#if canImport(UIKit)

import UIKit

// MARK: - ProxyTextField

/// An affordance layer wrapping a UITextField object.
/// Makes it easier to enforce UITextField's UTF-16 layout, as well as which properties and methods may be called.
///
/// - UITextField.text is never nil.
/// - UITextField.selectedTextRange is never nil.
///
public final class ProxyTextField {
    @usableFromInline typealias Wrapped = BasicTextField
    @usableFromInline typealias Offset = DiffableTextViews.Offset<UTF16>
    
    // MARK: Properties
    
    @usableFromInline let wrapped: Wrapped
    
    // MARK: Initializers
    
    @inlinable init(_ wrapped: Wrapped) {
        self.wrapped = wrapped
    }
    
    // MARK: Getters
    
    @inlinable var intent: Direction? {
        wrapped.intent
    }
    
    // MARK: Text

    /// - Complexity: O(1).
    @inlinable var text: String {
        wrapped.text!
    }
    
    /// - Complexity: High.
    @inlinable func update(text: String) {
        wrapped.text = text
    }
    
    // MARK: Selection
    
    /// - Complexity: O(1).
    @inlinable func selection() -> Range<Offset> {
        offsets(in: wrapped.selectedTextRange!)
    }
    
    /// - Complexity: High.
    @inlinable func select(offsets: Range<Offset>) {
        wrapped.selectedTextRange = positions(in: offsets)
    }
    
    // MARK: Descriptions
    
    /// - Complexity: O(1).
    @inlinable var edits: Bool {
        wrapped.isEditing
    }
    
    // MARK: Offsets

    /// - Complexity: O(1).
    @inlinable func offsets(in range: UITextRange) -> Range<Offset> {
        offset(at: range.start) ..< offset(at: range.end)
    }
    
    /// - Complexity: O(1).
    @inlinable func offset(at position: UITextPosition) -> Offset {
        .init(at: wrapped.offset(from: wrapped.beginningOfDocument, to: position))
    }
    
    // MARK: Positions
    
    /// - Complexity: O(1).
    @inlinable func position(at offset: Offset) -> UITextPosition {
        wrapped.position(from: wrapped.beginningOfDocument, offset: offset.units)!
    }
    
    /// - Complexity: O(1).
    @inlinable func positions(in offsets: Range<Offset>) -> UITextRange {
        wrapped.textRange(from: position(at: offsets.lowerBound), to: position(at: offsets.upperBound))!
    }
    
    // MARK: Transformations
    
    @inlinable public func resign() {
        wrapped.resignFirstResponder()
    }
        
    @inlinable public func autocorrect(_ autocorrect: UITextAutocorrectionType) {
        wrapped.autocorrectionType = autocorrect
    }
    
    @inlinable public func keyboard(_ keyboard: UIKeyboardType) {
        wrapped.keyboardType = keyboard
    }
    
    @inlinable public func key(return: UIReturnKeyType) {
        wrapped.returnKeyType = `return`
    }
    
    @inlinable public func secure(entry: Bool) {
        wrapped.isSecureTextEntry = entry
    }
    
    @inlinable public func tint(color: UIColor) {
        wrapped.tintColor = color
    }
}

#endif