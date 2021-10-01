//
//  TextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-01.
//

public protocol TextStyle {
    associatedtype Value = String
    
    func format(value: Value) -> String
    
    #warning("Document how partial values should be handled.")
    func parse(content: String) -> Value?
}
