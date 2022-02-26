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
// MARK: * Input
//*============================================================================*

public protocol Input {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func update(_ diffableTextField: ProxyTextField)
}

//*============================================================================*
// MARK: * Input x Instances
//*============================================================================*

extension Input where Self == AutocapitalizationInput {
    @inlinable static func autocapitalization(_ autocapitalization: UITextAutocapitalizationType) -> Self {
        Self(autocapitalization)
    }
}

extension Input where Self == AutocorrectionInput {
    @inlinable static func autocorrection(_ autocorrection: UITextAutocorrectionType) -> Self {
        Self(autocorrection)
    }
}

extension Input where Self == SecureInput {
    @inlinable static func secure(_ secure: Bool) -> Self {
        Self(secure)
    }
}

//*============================================================================*
// MARK: * Input x Autocapitalization
//*============================================================================*

public struct AutocapitalizationInput: Input {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let autocapitalization: UITextAutocapitalizationType
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ autocapitalization: UITextAutocapitalizationType) {
        self.autocapitalization = autocapitalization
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func update(_ diffableTextField: ProxyTextField) {
        diffableTextField.wrapped.autocapitalizationType = autocapitalization
    }
}

//*============================================================================*
// MARK: * Input x Autocorrection
//*============================================================================*

public struct AutocorrectionInput: Input {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let autocorrection: UITextAutocorrectionType
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ autocorrection: UITextAutocorrectionType) {
        self.autocorrection = autocorrection
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func update(_ diffableTextField: ProxyTextField) {
        diffableTextField.wrapped.autocorrectionType = autocorrection
    }
}

//*============================================================================*
// MARK: * Input x Secure
//*============================================================================*

public struct SecureInput: Input {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let secure: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ secure: Bool) {
        self.secure = secure
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func update(_ diffableTextField: ProxyTextField) {
        diffableTextField.wrapped.isSecureTextEntry = secure
    }
}

#endif
