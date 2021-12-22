//
//  NumberTextValue.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - NumberTextValue

#warning("WIP")
#warning("Rename, maybe.")
public protocol NumberValue: Boundable, Formattable, Precise {
    #warning("typealias NumberTextStyle = NumericTextStyles.NumberTextStyle<Self>")

    // MARK: Requirements
    
    associatedtype NumberParser: NumericTextStyles.NumberParser
}
