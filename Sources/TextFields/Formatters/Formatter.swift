//
//  Formatter.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-01.
//

@usableFromInline protocol Formatter {
    associatedtype FormatInput
    associatedtype FormatOutput
    associatedtype FormatFailure: Error = Never
    
    func format(_ value: FormatInput) -> Result<FormatOutput, FormatFailure>
}
