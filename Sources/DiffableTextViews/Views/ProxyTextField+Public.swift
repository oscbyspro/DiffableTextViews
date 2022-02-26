//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// This file contains ProxyTextField's public interface.
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import UIKit

//=----------------------------------------------------------------------------=
// MARK: + Accessors
//=----------------------------------------------------------------------------=

extension ProxyTextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Text
    //=------------------------------------------------------------------------=
    
    @inlinable public var text: String {
        wrapped.text! // force unwrapping is always OK
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Actions
//=----------------------------------------------------------------------------=

extension ProxyTextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Resign
    //=------------------------------------------------------------------------=
    
    @inlinable public func resign() {
        wrapped.resignFirstResponder()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Customization
//=----------------------------------------------------------------------------=

extension ProxyTextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Appearance
    //=------------------------------------------------------------------------=
        
    @inlinable public func tint(_ tint: UIColor) {
        wrapped.tintColor = tint
    }

    @inlinable public func font(_ font: UIFont) {
        wrapped.font = font
    }
        
    @inlinable public func font(_ font: DiffableTextFont) {
        wrapped.font = UIFont(font)
    }

    //=------------------------------------------------------------------------=
    // MARK: Input
    //=------------------------------------------------------------------------=

    @inlinable public func input( _ input: Input) {
        wrapped.isSecureTextEntry = input == .secure
    }
    
    @inlinable public func autocorrection(_ autocorrection: UITextAutocorrectionType) {
        wrapped.autocorrectionType = autocorrection
    }
    
    @inlinable public func autocapitalization(_ autocapitalization: UITextAutocapitalizationType) {
        wrapped.autocapitalizationType = autocapitalization
    }

    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable public func keyboard(_ keyboard: UIKeyboardType) {
        wrapped.keyboardType = keyboard
    }

    @inlinable public func submission(_ submission: UIReturnKeyType) {
        wrapped.returnKeyType = submission
    }

    //=------------------------------------------------------------------------=
    // MARK: System / Information
    //=------------------------------------------------------------------------=

    @inlinable public func content(_ content: UITextContentType) {
        wrapped.textContentType = content
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Helpers
//=----------------------------------------------------------------------------=

extension ProxyTextField {
    
    //*========================================================================*
    // MARK: * Input
    //*========================================================================*
    
    public enum Input { case standard, secure }
}

#endif
