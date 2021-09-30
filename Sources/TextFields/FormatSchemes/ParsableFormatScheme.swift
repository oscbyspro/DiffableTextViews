//
//  ParsableFormatScheme.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-30.
//

protocol ParsableFormatScheme: FormatScheme {
    associatedtype Inverse: FormatScheme where Inverse.Input == Output, Inverse.Output == Input
    
    // MARK: Get
    
    var inverse: Inverse { get }
}

extension ParsableFormatScheme {
    // MARK: Parse
    
    @inlinable func parse(_ content: Output) -> Result<Input, Inverse.Failure> {
        inverse.format(content)
    }
}
