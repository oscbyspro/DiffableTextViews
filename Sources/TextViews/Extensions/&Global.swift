//
//  &Global.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-27.
//

// MARK: - Pipes

@inlinable func pipe<X0, X1, X2>(
    _ x1: @escaping (X0) -> X1,
    _ x2: @escaping (X1) -> X2
) -> (X0) -> X2 {{ x0 in x2(x1(x0)) }}

@inlinable func pipe<X0, X1, X2, X3>(
    _ x1: @escaping (X0) -> X1,
    _ x2: @escaping (X1) -> X2,
    _ x3: @escaping (X2) -> X3
) -> (X0) -> X3 {{ x0 in x3(x2(x1(x0))) }}
