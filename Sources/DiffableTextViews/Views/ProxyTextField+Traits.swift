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

public final class ProxyTextField_Traits {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let wrapped: BasicTextField
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ wrapped: BasicTextField) { self.wrapped = wrapped }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable public func autocorrection(_ autocorrection: UITextAutocorrectionType) {
        wrapped.autocorrectionType = autocorrection
    }
    
    @inlinable public func autocapitalization(_ autocapitalization: UITextAutocapitalizationType) {
        wrapped.autocapitalizationType = autocapitalization
    }
    
    @inlinable public func content(_ content: UITextContentType) {
        wrapped.textContentType = content
    }
    
    @inlinable public func entry( _ entry: Entry) {
        wrapped.isSecureTextEntry = entry == .secure
    }

    //*============================================================================*
    // MARK: * Entry
    //*============================================================================*
    
    public enum Entry { case normal, secure }
}

#endif
