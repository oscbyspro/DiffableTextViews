//
//  Proxy.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

#if os(iOS)

import UIKit

// MARK: - Proxy

/// An affordance layer wrapping a UITextField object.
///
/// - UITextField.text is never nil.
/// - UITextField.selectedTextRange is never nil
@usableFromInline final class Proxy {
    @usableFromInline typealias Offset = TextViews.Offset<UTF16>
    
    // MARK: Properties
    
    @usableFromInline let uiTextField: UITextField
    
    // MARK: Initializers
    
    @inlinable init(_ uiTextField: UITextField) {
        self.uiTextField = uiTextField
    }
    
    // MARK: Text
    
    /// - Complexity: O(1).
    @inlinable var text: String {
        uiTextField.text!
    }
    
    /// - Complexity: High.
    @inlinable func write(_ text: String) {
        uiTextField.text = text
    }
    
    // MARK: Selection
    
    /// - Complexity: O(1).
    @inlinable func selection() -> Range<Offset> {
        offsets(in: uiTextField.selectedTextRange!)
    }
    
    /// - Complexity: High.
    @inlinable func select(_ offsets: Range<Offset>) {
        uiTextField.selectedTextRange = positions(of: offsets)
    }
    
    // MARK: Descriptions
    
    /// - Complexity: O(1).
    @inlinable var edits: Bool {
        uiTextField.isEditing
    }
    
    // MARK: Helpers: Range & Offset

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
        uiTextField.position(from: uiTextField.beginningOfDocument, offset: offset.distance)!
    }
    
    /// - Complexity: O(1).
    @inlinable func positions(of offsets: Range<Offset>) -> UITextRange {
        uiTextField.textRange(from: position(at: offsets.lowerBound), to: position(at: offsets.upperBound))!
    }
}

#endif
