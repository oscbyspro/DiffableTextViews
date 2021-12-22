//
//  NumberTextValue.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - NumberTextValue

public protocol NumberTextValue: Parsable, Formattable, Boundable, Precise {
    typealias NumberTextStyle = NumericTextStyles.NumberTextStyle<Self>
}
