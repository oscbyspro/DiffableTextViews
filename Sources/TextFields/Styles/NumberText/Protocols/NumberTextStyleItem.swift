//
//  NumberTextStyleItem.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
public protocol NumberTextStyleItem: NumberTextValuesItem, NumberTextPrecisionItem {
    associatedtype Style: FormatStyle where Style.FormatInput == Number, Style.FormatOutput == String
    
    // MARK: Aliases
    
    typealias Configuration = NumberFormatStyleConfiguration
    typealias Precision = Configuration.Precision
    typealias Separator = Configuration.DecimalSeparatorDisplayStrategy
    
    // MARK: Utilities
    
    @inlinable static func number(_ components: NumberTextComponents) -> Number?
    
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> Style
}
