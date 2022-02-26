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
    
    #warning("TODO")
    //=------------------------------------------------------------------------=
    // MARK: Color
    //=------------------------------------------------------------------------=
        
    @inlinable func color<ID>(_ token: Token<ID>) where ID: ColorID {
        accept(token)
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
    
    @inlinable func key<ID>(_ token: Token<ID>) where ID: KeyID {
        accept(token)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Input
    //=------------------------------------------------------------------------=

    @inlinable func input<ID>(_ token: Token<ID>) where ID: InputID {
        accept(token)
    }

    #warning("TODO")
    //=------------------------------------------------------------------------=
    // MARK: System / Information
    //=------------------------------------------------------------------------=

    @inlinable func content(_ content: UITextContentType) {
        wrapped.textContentType = content
    }
}

#endif
