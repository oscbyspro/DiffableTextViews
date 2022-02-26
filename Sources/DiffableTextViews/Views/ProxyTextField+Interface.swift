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

public extension ProxyTextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Text
    //=------------------------------------------------------------------------=
    
    @inlinable var text: String {
        wrapped.text! // force unwrapping is always OK
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
        Task { @MainActor in wrapped.resignFirstResponder() }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Customization
//=----------------------------------------------------------------------------=

public extension ProxyTextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Appearance
    //=------------------------------------------------------------------------=
        
    @inlinable func tint(_ tint: UIColor) {
        wrapped.tintColor = tint
    }

    @inlinable func font(_ font: UIFont) {
        wrapped.font = font
    }
        
    @inlinable func font(_ font: DiffableTextFont) {
        wrapped.font = UIFont(font)
    }

    //=------------------------------------------------------------------------=
    // MARK: Input
    //=------------------------------------------------------------------------=

    @inlinable func input<Style>(_ input: Style) where Style: Input {
        transform(input.update)
    }

    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable func keyboard(_ keyboard: UIKeyboardType) {
        wrapped.keyboardType = keyboard
    }
    
    @inlinable func key<Key>(_ key: Key) where Key: KeyOnKeyboard {
        transform(key.update)
    }

    //=------------------------------------------------------------------------=
    // MARK: System / Information
    //=------------------------------------------------------------------------=

    @inlinable func content(_ content: UITextContentType) {
        wrapped.textContentType = content
    }
}

#endif
