//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import SwiftUI
import UIKit

//*============================================================================*
// MARK: * ProxyTextField
//*============================================================================*

public final class ProxyTextField: BasicTextField.View {
    public final class Keyboard:   BasicTextField.View { }
    public final class Selection:  BasicTextField.View { }
    public final class Text:       BasicTextField.View { }
    public final class Traits:     BasicTextField.View { }
    public final class View:       BasicTextField.View { }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var keyboard: Keyboard {
        Keyboard(wrapped)
    }
    
    @inlinable public var selection: Selection {
        Selection(wrapped)
    }
    
    @inlinable public var text: Text {
        Text(wrapped)
    }
    
    @inlinable public var traits: Traits {
        Traits(wrapped)
    }
    
    @inlinable public var view: View {
        View(wrapped)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Actions
    //=------------------------------------------------------------------------=
    
    /// Asks the view to relinquish its status as first responder in its window.
    ///
    /// SwiftUI.FocusState is the preferred focusing mechanism in most cases.
    ///
    @inlinable public func dismiss() {
        Task { @MainActor in wrapped.resignFirstResponder() }
    }
}

//*============================================================================*
// MARK: * Keyboard
//*============================================================================*

public extension ProxyTextField.Keyboard {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func appearance(_ appearance: UIKeyboardAppearance) {
        wrapped.keyboardAppearance = appearance
    }
    
    @inlinable func submit(_ submit: UIReturnKeyType) {
        wrapped.returnKeyType = submit
    }
    
    @inlinable func view(_ keyboard: UIKeyboardType) {
        wrapped.keyboardType = keyboard
    }
}

//*============================================================================*
// MARK: * Selection
//*============================================================================*

public extension ProxyTextField.Selection {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var value: String {
        // UITextField.selectedTextRange is never nil
        wrapped.text(in: wrapped.selectedTextRange!)!
    }
    
    @inlinable var marked: String {
        // UITextField.markedTextRange is sometimes nil
        wrapped.markedTextRange.flatMap(wrapped.text(in:)) ?? String()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func color(_ color: UIColor) {
        wrapped.tintColor = color
    }

    @inlinable func color(mode: UIView.TintAdjustmentMode) {
        wrapped.tintAdjustmentMode = mode
    }
    
    @inlinable func color(_ color: UIColor, mode: UIView.TintAdjustmentMode) {
        self.color(color); self.color(mode: mode)
    }
}

//*============================================================================*
// MARK: * Text
//*============================================================================*

public extension ProxyTextField.Text {

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var value: String {
        wrapped.text! // UITextField.text is never nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable func alignment(_  alignment: TextAlignment) {
        wrapped.setTextAlignment(alignment)
    }
    
    @inlinable func color(_ color: UIColor) {
        wrapped.textColor = color
    }

    @inlinable func font(_ font: UIFont) {
        wrapped.font = font
    }
    
    @inlinable func font(_ font: DiffableTextFont) {
        wrapped.font = UIFont(font)
    }
}

//*============================================================================*
// MARK: * Traits
//*============================================================================*

public extension ProxyTextField.Traits {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable func autocorrection(_ autocorrection: UITextAutocorrectionType) {
        wrapped.autocorrectionType = autocorrection
    }
    
    @inlinable func autocapitalization(_ autocapitalization: UITextAutocapitalizationType) {
        wrapped.autocapitalizationType = autocapitalization
    }
    
    @inlinable func content(_ content: UITextContentType) {
        wrapped.textContentType = content
    }
    
    @inlinable func entry(_ entry:  Entry) {
        wrapped.isSecureTextEntry = entry == .secure
    }
    
    //*========================================================================*
    // MARK: * Components
    //*========================================================================*
    
    enum Entry { case normal, secure }
}

//*============================================================================*
// MARK: * View
//*============================================================================*

public extension ProxyTextField.View {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func background( _ color: UIColor?) {
        wrapped.backgroundColor = color
    }
    
    @inlinable func border( _ border: UITextField.BorderStyle) {
        wrapped.borderStyle = border
    }
}

#endif
