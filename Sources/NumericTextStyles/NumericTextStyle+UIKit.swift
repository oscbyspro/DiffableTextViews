//
//  NumericTextStyle+UIKit.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-31.
//

#if canImport(UIKit)

import UIKit
import DiffableTextViews

//=----------------------------------------------------------------------------=
// MARK: NumericTextStyle - UIKit
//=----------------------------------------------------------------------------=

extension NumericTextStyle: UIKitDiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable public static func onSetup(_ diffableTextField: ProxyTextField) {
        diffableTextField.keyboard(Value.isInteger ? .numberPad : .decimalPad)
    }
}

#endif
