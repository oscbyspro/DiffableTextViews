//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-12.
//

#if canImport(UIKit)

import UIKit

//*============================================================================*
// MARK: * UIKitCompatibleStyle
//*============================================================================*

public protocol UIKitCompatibleStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable var keyboard: UIKeyboardType { get }
}

//=----------------------------------------------------------------------------=
// MARK: UIKitCompatibleStyle - Implementation
//=----------------------------------------------------------------------------=

extension UIKitCompatibleStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable var keyboard: UIKeyboardType {
        .default
    }
}

//*============================================================================*
// MARK: DiffableTextStyle x UIKitCompatibleStyle
//*============================================================================*

extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    @inlinable func setup(_ proxy: ProxyTextField) {
        guard let self = self as? UIKitCompatibleStyle else { return }
        proxy.keyboard(self.keyboard)
    }
}

#endif
