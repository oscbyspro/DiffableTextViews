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
// MARK: * ProxyTextField x Behavior
//*============================================================================*

public final class ProxyTextField_Behavior {
    
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
    
    @inlinable public func secure(_ secure: Bool) {
        wrapped.isSecureTextEntry = secure
    }

    @inlinable public func autocorrection(_ autocorrection: UITextAutocorrectionType) {
        wrapped.autocorrectionType = autocorrection
    }
    
    @inlinable public func autocapitalization(_ autocapitalization: UITextAutocapitalizationType) {
        wrapped.autocapitalizationType = autocapitalization
    }
}

#endif
