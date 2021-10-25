//
//  DiffableTextField+Styles.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-24.
//

import SwiftUI

// MARK: - DiffableTextField + NumericTextStyle

public extension DiffableTextField {
    
    // MARK: Initializers
    
    @inlinable init<Number: NumericTextSchematic>(value: Binding<Number>, style: Style) where Style == Number.NumericTextStyle {
        self.init(value: value, style: style)
    }
    
    @inlinable init<Number: NumericTextSchematic>(value: Binding<Number>, style:  () -> Style) where Style == Number.NumericTextStyle {
        self.init(value: value, style: style)
    }
}
