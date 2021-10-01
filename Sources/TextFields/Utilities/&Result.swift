//
//  &Result.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-01.
//

extension Result where Failure == Never {
    @inlinable func get() -> Success {
        switch self {
        case .success(let success): return success
        }
    }
}

