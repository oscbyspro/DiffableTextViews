//
//  $Operators.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-28.
//

precedencegroup PipeOperator {
    associativity: left
}

infix operator |>>> : PipeOperator

@inlinable func |>>> <Input, Output>(input: Input, transform: ((Input) -> Output)) -> Output {
    transform(input)
}
