//
//  NumberTextValue.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - NumberTextValue

#warning("WIP")
#warning("Rename, maybe.")
public protocol _NumberTextValue: _Boundable, _Formattable, _Precise {
    #warning("typealias NumberTextStyle = NumericTextStyles.NumberTextStyle<Self>")

    // MARK: Requirements
    
    associatedtype NumberTextParser: NumericTextStyles._NumberTextParser
}
