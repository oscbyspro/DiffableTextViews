//
//  NumberTextValue.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - NumberTextValue

public protocol NumberTextValue: Boundable, Formattable, PreciseValue {
    typealias NumberTextStyle = NumericTextStyles.NumberTextStyle<Self>

    // MARK: Requirements
    
    associatedtype NumberParser: NumericTextStyles.NumberTextParser
}
