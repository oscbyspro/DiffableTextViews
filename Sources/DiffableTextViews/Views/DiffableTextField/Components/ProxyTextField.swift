//
//  ProxyTextField.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

#if canImport(UIKit)

import UIKit
import struct SwiftUI.Color

// MARK: - ProxyTextField

/// An affordance layer wrapping a UITextField object.
/// Makes it easier to enforce UITextField's UTF-16 layout.
///
/// - UITextField.text is never nil.
/// - UITextField.selectedTextRange is never nil.
///
public final class ProxyTextField<Wrapped: UITextField> {
    @usableFromInline typealias Offset = DiffableTextViews.Offset<UTF16>
    
    // MARK: Properties
    
    @usableFromInline let uiTextField: Wrapped
    
    // MARK: Initializers
    
    @inlinable init(_ uiTextField: Wrapped) {
        self.uiTextField = uiTextField
    }
    
    // MARK: Text

    /// - Complexity: O(1).
    @inlinable var text: String {
        uiTextField.text!
    }
    
    /// - Complexity: High.
    @inlinable func update(text: String) {
        uiTextField.text = text
    }
    
    // MARK: Selection
    
    /// - Complexity: O(1).
    @inlinable func selection() -> Range<Offset> {
        offsets(in: uiTextField.selectedTextRange!)
    }
    
    /// - Complexity: High.
    @inlinable func select(offsets: Range<Offset>) {
        uiTextField.selectedTextRange = positions(of: offsets)
    }
    
    // MARK: Descriptions
    
    /// - Complexity: O(1).
    @inlinable var edits: Bool {
        uiTextField.isEditing
    }
    
    // MARK: Range & Offset

    /// - Complexity: O(1).
    @inlinable func offsets(in bounds: UITextRange) -> Range<Offset> {
        offset(at: bounds.start) ..< offset(at: bounds.end)
    }
    
    /// - Complexity: O(1).
    @inlinable func offset(at position: UITextPosition) -> Offset {
        .init(at: uiTextField.offset(from: uiTextField.beginningOfDocument, to: position))
    }
    
    /// - Complexity: O(1).
    @inlinable func position(at offset: Offset) -> UITextPosition {
        uiTextField.position(from: uiTextField.beginningOfDocument, offset: offset.units)!
    }
    
    /// - Complexity: O(1).
    @inlinable func positions(of offsets: Range<Offset>) -> UITextRange {
        uiTextField.textRange(from: position(at: offsets.lowerBound), to: position(at: offsets.upperBound))!
    }
    
    // MARK: Transformations
    
    @inlinable public func resign() {
        uiTextField.resignFirstResponder()
    }
        
    @inlinable public func autocorrect(_ autocorrect: UITextAutocorrectionType) {
        uiTextField.autocorrectionType = autocorrect
    }
    
    @inlinable public func keyboard(_ keyboard: UIKeyboardType) {
        uiTextField.keyboardType = keyboard
    }
    
    @inlinable public func key(return: UIReturnKeyType) {
        uiTextField.returnKeyType = `return`
    }
    
    @inlinable public func secure(entry: Bool) {
        uiTextField.isSecureTextEntry = entry
    }
    
    @inlinable public func tint(color: UIColor) {
        uiTextField.tintColor = color
    }
    
    @inlinable public func tint(color: Color) {
        uiTextField.tintColor = UIColor(color)
    }
}

#endif
