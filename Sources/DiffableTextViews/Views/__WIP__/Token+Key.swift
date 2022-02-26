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
// MARK: * Token x Key
//*============================================================================*

public protocol KeyID: TokenID { }

//*============================================================================*
// MARK: * Token x Key x Submit
//*============================================================================*

public enum SubmitKeyID: KeyID {
    @inlinable public static func update(_ view: UITextField, with value: UIReturnKeyType) {
        view.returnKeyType = value
    }
}

extension Token where ID == SubmitKeyID {
    @inlinable public static func submit(_ submit: Value) -> Self {
        Self(submit)
    }
}

#endif
