//
//  $Operators.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-28.
//

precedencegroup PipePrecedence {
    associativity: left
    higherThan: BitwiseShiftPrecedence
}

infix operator |>>> : PipePrecedence

@inlinable func |>>> <Input, Output>(input: Input, closure: ((Input) -> Output)) -> Output {
    closure(input)
}
