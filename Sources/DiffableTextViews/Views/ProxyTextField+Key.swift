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
// MARK: * KeyOnKeyboard
//*============================================================================*

public protocol KeyOnKeyboard {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func update(_ diffableTextField: ProxyTextField)
}

//*============================================================================*
// MARK: * KeyOnKeyboard x Submit
//*============================================================================*

public struct SubmitKeyOnKeyboard: KeyOnKeyboard {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let key: UIReturnKeyType
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ key: UIReturnKeyType) { self.key = key }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func update(_ diffableTextField: ProxyTextField) {
        diffableTextField.wrapped.returnKeyType = key
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Instances
//=----------------------------------------------------------------------------=

public extension KeyOnKeyboard where Self == SubmitKeyOnKeyboard {
    @inlinable static func submit(_ submit: UIReturnKeyType) -> Self {
        Self(submit)
    }
}

#endif
