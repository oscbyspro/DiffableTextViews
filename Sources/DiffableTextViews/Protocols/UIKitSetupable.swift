//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-12.
//

#if canImport(UIKit)

import UIKit

//*============================================================================*
// MARK: * UIKitSetupable
//*============================================================================*

public protocol UIKitSetupable {
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable var keyboard: UIKeyboardType { get }
}

//=----------------------------------------------------------------------------=
// MARK: UIKitSetupable - Implementation
//=----------------------------------------------------------------------------=

extension UIKitSetupable {
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable var keyboard: UIKeyboardType {
        .default
    }
}

//*============================================================================*
// MARK: DiffableTextStyle x UIKitSetupable
//*============================================================================*

extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    @inlinable func setup(_ proxy: ProxyTextField) {
        guard let existential = self as? UIKitSetupable else { return }
        proxy.keyboard(existential.keyboard)
    }
}

#endif
