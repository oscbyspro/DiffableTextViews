//
//  &DiffableTextField.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import SwiftUI
import DiffableTextViews

// MARK: - DiffableTextField

public extension DiffableTextField {
    
    // MARK: Initializers
    
    @inlinable init<Value: NumericTextValue>(_ value: Binding<Value>, style: Value.NumericTextStyle) where Style == Value.NumericTextStyle {
        self.init(value, style: style)
    }
    
    @inlinable init<Value: NumericTextValue>(_ value: Binding<Value>, style: () -> Value.NumericTextStyle) where Style == Value.NumericTextStyle {
        self.init(value, style: style)
    }
}
