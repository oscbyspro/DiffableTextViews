//
//  ProxyTextField.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

#if canImport(UIKit)

import UIKit

//*============================================================================*
// MARK: * ProxyTextField
//*============================================================================*

/// A UITextField affordance layer.
public final class ProxyTextField {
    @usableFromInline typealias Wrapped = BasicTextField
    @usableFromInline typealias Position = DiffableTextViews.Position<UTF16>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let wrapped: Wrapped
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ wrapped: Wrapped) {
        self.wrapped = wrapped
        self.font(.body.monospaced())
    }
}

//=----------------------------------------------------------------------------=
// MARK: ProxyTextField - Internal
//=----------------------------------------------------------------------------=

extension ProxyTextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var active: Bool {
        wrapped.isEditing
    }

    @inlinable var momentum: Bool {
        wrapped.momentum
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors - Text, Selection
    //=------------------------------------------------------------------------=
    
    @inlinable var text: String {
        wrapped.text!
    }
    
    @inlinable func selection() -> Range<Position> {
        offsets(in: wrapped.selectedTextRange!)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func update(text: String) {
        wrapped.text = text
    }
    
    @inlinable func update(selection: Range<Position>) {
        wrapped.selectedTextRange = positions(in: selection)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Positions
    //=------------------------------------------------------------------------=

    /// - Complexity: O(1).
    @inlinable func offsets(in range: UITextRange) -> Range<Position> {
        offset(at: range.start) ..< offset(at: range.end)
    }
    
    /// - Complexity: O(1).
    @inlinable func offset(at position: UITextPosition) -> Position {
        Position(wrapped.offset(from: wrapped.beginningOfDocument, to: position))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Layout
    //=------------------------------------------------------------------------=
    
    /// - Complexity: O(1).
    @inlinable func position(at offset: Position) -> UITextPosition {
        wrapped.position(from: wrapped.beginningOfDocument, offset: offset.offset)!
    }
    
    /// - Complexity: O(1).
    @inlinable func positions(in offsets: Range<Position>) -> UITextRange {
        wrapped.textRange(from: position(at: offsets.lowerBound), to: position(at: offsets.upperBound))!
    }
}

//=----------------------------------------------------------------------------=
// MARK: ProxyTextField - Actions
//=----------------------------------------------------------------------------=

public extension ProxyTextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Resign
    //=------------------------------------------------------------------------=
    
    @inlinable func resign() {
        wrapped.resignFirstResponder()
    }
}

//=----------------------------------------------------------------------------=
// MARK: ProxyTextField - Transformations
//=----------------------------------------------------------------------------=

public extension ProxyTextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ position: UITextAutocorrectionType) {
        wrapped.autocorrectionType = position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Content
    //=------------------------------------------------------------------------=
    
    @inlinable func content(_ content: UITextContentType) {
        wrapped.textContentType = content
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Entry
    //=------------------------------------------------------------------------=
        
    @inlinable func entry(secure: Bool) {
        wrapped.isSecureTextEntry = secure
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Font
    //=------------------------------------------------------------------------=
    
    @inlinable func font(_ font: UIFont) {
        wrapped.font = font
    }
        
    @inlinable func font(_ font: OBEFont) {
        wrapped.font = UIFont(font)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable func keyboard(_ keyboard: UIKeyboardType) {
        wrapped.keyboardType = keyboard
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Key
    //=------------------------------------------------------------------------=
    
    @inlinable func key(return: UIReturnKeyType) {
        wrapped.returnKeyType = `return`
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tint
    //=------------------------------------------------------------------------=
        
    @inlinable func tint(color: UIColor) {
        wrapped.tintColor = color
    }
}

#endif
