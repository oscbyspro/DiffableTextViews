//
//  ProxyTextField.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

#if os(iOS)

import UIKit

// MARK: - ProxyTextField

/// An affordance layer wrapping a UITextField object.
///
/// - UITextField.text is never nil.
/// - UITextField.selectedTextRange is never nil
@usableFromInline final class ProxyTextField<Wrapped: UITextField> {
    @usableFromInline typealias Offset = DiffableTextViews.Offset<UTF16>
    
    // MARK: Properties
    
    @usableFromInline let wrapped: Wrapped
    
    // MARK: Initializers
    
    @inlinable init(_ wrapped: Wrapped) {
        self.wrapped = wrapped
    }
    
    // MARK: Text
    
    /// - Note: Force unwrapping the UITextField's text is always OK,
    /// because it can never be nil. It is a relic of Apple's Objective-C implementation.
    ///
    /// - Complexity: O(1).
    @inlinable var text: String {
        wrapped.text!
    }
    
    /// - Complexity: High.
    @inlinable func write(_ text: String) {
        wrapped.text = text
    }
    
    // MARK: Selection
    
    /// - Note: Force unwrapping the UITextField's selection is always OK,
    /// because it can never be nil. It is a relic of Apple's Objective-C implementation.
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
    
    // MARK: Helpers: Range & Offset

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

#endif
