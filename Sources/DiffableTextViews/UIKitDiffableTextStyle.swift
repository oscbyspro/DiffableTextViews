//
//  UIKitDiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-12.
//

#if canImport(UIKit)

import UIKit

//*============================================================================*
// MARK: * UIKitDiffableTextStyle
//*============================================================================*

public protocol UIKitDiffableTextStyle: DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    /// Configures the text field at setup.
    ///
    /// - The default implementation returns immediately.
    ///
    @inlinable static func setup(diffableTextField: ProxyTextField)
}

//=----------------------------------------------------------------------------=
// MARK: UIKitDiffableTextStyle - Implementation
//=----------------------------------------------------------------------------=

public extension UIKitDiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    @inlinable static func setup(diffableTextField: ProxyTextField) { }
}

#endif
