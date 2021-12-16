//
//  ProxyTextField.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

#if os(iOS)

import UIKit
import SwiftUI

// MARK: - ProxyTextField

/// An affordance layer wrapping a UITextField object.
/// Makes it easier to enforce UITextField's UTF-16 layout.
///
/// - UITextField.text is never nil.
/// - UITextField.selectedTextRange is never nil.
public final class ProxyTextField<Wrapped: UITextField> {
    @usableFromInline typealias Offset = DiffableTextViews.Offset<UTF16>
    
    // MARK: Properties
    
    @usableFromInline let wrapped: Wrapped
    
    // MARK: Initializers
    
    @inlinable init(_ wrapped: Wrapped) {
        self.wrapped = wrapped
    }
    
    // MARK: Text
    
    /// - Note: Force unwrapping a UITextField's text is always OK.
    ///
    /// - Complexity: O(1).
    @inlinable var text: String {
        wrapped.text!
    }
    
    /// - Complexity: High.
    @inlinable func update(_ text: String) {
        wrapped.text = text
    }
    
    // MARK: Selection
    
    /// - Note: Force unwrapping a UITextField's selection is always OK.
    ///
    /// - Complexity: O(1).
    @inlinable func selection() -> Range<Offset> {
        offsets(in: wrapped.selectedTextRange!)
    }
    
    /// - Complexity: High.
    @inlinable func select(_ offsets: Range<Offset>) {
        wrapped.selectedTextRange = positions(of: offsets)
    }
    
    // MARK: Descriptions
    
    /// - Complexity: O(1).
    @inlinable var edits: Bool {
        wrapped.isEditing
    }
    
    // MARK: Utilities: Range & Offset

    /// - Complexity: O(1).
    @inlinable func offsets(in bounds: UITextRange) -> Range<Offset> {
        offset(at: bounds.start) ..< offset(at: bounds.end)
    }
    
    /// - Complexity: O(1).
    @inlinable func offset(at position: UITextPosition) -> Offset {
        .init(at: wrapped.offset(from: wrapped.beginningOfDocument, to: position))
    }
    
    /// - Complexity: O(1).
    @inlinable func position(at offset: Offset) -> UITextPosition {
        wrapped.position(from: wrapped.beginningOfDocument, offset: offset.distance)!
    }
    
    /// - Complexity: O(1).
    @inlinable func positions(of offsets: Range<Offset>) -> UITextRange {
        wrapped.textRange(from: position(at: offsets.lowerBound), to: position(at: offsets.upperBound))!
    }
}

// MARK: - Public Interface

public extension ProxyTextField {
        
    // MARK: Actions
    
    @inlinable func resign() {
        wrapped.resignFirstResponder()
    }
    
    // MARK: Setters
    
    @inlinable func autocorrect(_ autocorrect: UITextAutocorrectionType) {
        wrapped.autocorrectionType = autocorrect
    }
    
    @inlinable func caret(_ color: Color) {
        wrapped.tintColor = UIColor(color)
    }
    
    @inlinable func keyboard(_ keyboard: UIKeyboardType) {
        wrapped.keyboardType = keyboard
    }
    
    @inlinable func `return`(_ key: UIReturnKeyType) {
        wrapped.returnKeyType = key
    }
    
    @inlinable func secure(_ secure: Bool) {
        wrapped.isSecureTextEntry = secure
    }
}

#endif
