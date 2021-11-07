//
//  NumericTextValue.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

public protocol NumericTextValue: Boundable, Precise, Formattable {
    typealias NumericTextStyle = NumericTextStyleKit.NumericTextStyle<Self>
}
