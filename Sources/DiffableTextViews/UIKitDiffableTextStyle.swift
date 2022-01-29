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
    @inlinable static func onSetup(_ diffableTextField: ProxyTextField)
}

//=----------------------------------------------------------------------------=
// MARK: UIKitDiffableTextStyle - Details
//=----------------------------------------------------------------------------=

public extension UIKitDiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    @inlinable static func onSetup(_ diffableTextField: ProxyTextField) { }
}

#endif
