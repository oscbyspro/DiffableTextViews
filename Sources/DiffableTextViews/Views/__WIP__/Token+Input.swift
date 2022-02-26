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
// MARK: * Token x Input
//*============================================================================*

public protocol InputID: TokenID { }

//*============================================================================*
// MARK: * Token x Input x Secure
//*============================================================================*

public enum SecureInputID: InputID {
    @inlinable public static func update(_ view: UITextField, with value: Bool) {
        view.isSecureTextEntry = value
    }
}

extension Token where ID == SecureInputID {
    @inlinable public static func secure(_ secure: Value) -> Self {
        Self(secure)
    }
}

//*============================================================================*
// MARK: * Token x Input x Autocorrection
//*============================================================================*

public enum AutocorrectionInputID: InputID {
    @inlinable public static func update(_ view: UITextField, with value: UITextAutocorrectionType) {
        view.autocorrectionType = value
    }
}

extension Token where ID == AutocorrectionInputID {
    @inlinable public static func autocorrection(_ autocorrection: Value) -> Self {
        Self(autocorrection)
    }
}

//*============================================================================*
// MARK: * Token x Input x Autocapitalization
//*============================================================================*

public enum AutocapitalizationInputID: InputID {
    @inlinable public static func update(_ view: UITextField, with value: UITextAutocapitalizationType) {
        view.autocapitalizationType = value
    }
}

extension Token where ID == AutocapitalizationInputID {
    @inlinable public static func autocapitalization(_ autocapitalization: Value) -> Self {
        Self(autocapitalization)
    }
}

#endif
