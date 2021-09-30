//
//  ParsableFormat.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-30.
//

protocol ParsableFormat: Format {
    associatedtype Inverse: Format where Inverse.Input == Output, Inverse.Output == Input
    
    // MARK: Get
    
    var inverse: Inverse { get }
}

extension ParsableFormat {
    // MARK: Parse
    
    @inlinable func parse(_ value: Output) -> Result<Input, Inverse.Failure> {
        inverse.format(value)
    }
}
