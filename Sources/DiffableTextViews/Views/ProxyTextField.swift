//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

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
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let wrapped: Wrapped
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ wrapped: Wrapped) {
        self.wrapped = wrapped
        self.font(.body.monospaced())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func transform(_ transform: (ProxyTextField) -> Void) {
        transform(self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Internal
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
        wrapped.text! // force unwrap is always OK
    }
    
    @inlinable func selection() -> Range<Position> {
        offsets(in: wrapped.selectedTextRange!) // force unwrap is always OK
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
// MARK: + Actions
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
// MARK: + Transformations
//=----------------------------------------------------------------------------=

public extension ProxyTextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ autocorrect: UITextAutocorrectionType) {
        wrapped.autocorrectionType = autocorrect
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Color
    //=------------------------------------------------------------------------=
        
    @inlinable func tint(_ color: UIColor) {
        wrapped.tintColor = color
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
        
    @inlinable func entry(_ entry: Entry) {
        wrapped.isSecureTextEntry = entry == .secure
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Font
    //=------------------------------------------------------------------------=
    
    @inlinable func font(_ font: UIFont) {
        wrapped.font = font
    }
        
    @inlinable func font(_ font: DiffableTextFont) {
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
    
    @inlinable func submit(_ key: UIReturnKeyType) {
        wrapped.returnKeyType = key
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Helpers
//=----------------------------------------------------------------------------=

public extension ProxyTextField {
    
    //*========================================================================*
    // MARK: * Entry
    //*========================================================================*
    
    /// Semantic values for UITextField's isSecureTextEntry boolean.
    enum Entry { case standard, secure }
}

#endif
