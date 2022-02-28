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
// MARK: * ProxyTextField x Traits
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
    
    @inlinable func entry( _ entry: Entry) {
        wrapped.isSecureTextEntry = entry == .secure
    }
    
    //*========================================================================*
    // MARK: * Entry
    //*========================================================================*
    
    enum Entry { case normal, secure }
}

#endif
