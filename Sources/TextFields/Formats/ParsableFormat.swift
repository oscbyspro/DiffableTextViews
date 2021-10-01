//
//  ParsableFormat.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-30.
//

protocol ParsableFormat: Format {
    associatedtype Parser: Format where Parser.Input == Output, Parser.Output == Input
    
    // MARK: Get
    
    var parser: Parser { get }
}

extension ParsableFormat {
    // MARK: Parse
    
    @inlinable func parse(_ value: Output) -> Result<Input, Parser.Failure> {
        parser.format(value)
    }
}
