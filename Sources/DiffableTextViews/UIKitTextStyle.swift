//
//  UIKitTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-12.
//

#if canImport(UIKit)

import UIKit

//*============================================================================*
// MARK: * UIKitTextStyle
//*============================================================================*

public protocol UIKitTextStyle: DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    @inlinable func setup(_ proxy: ProxyTextField)
}

//=----------------------------------------------------------------------------=
// MARK: UIKitTextStyle - Implementation
//=----------------------------------------------------------------------------=

public extension UIKitTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    @inlinable func setup(_ proxy: ProxyTextField) { }
}

#endif
