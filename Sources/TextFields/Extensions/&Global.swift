//
//  &Global.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

@inlinable func update<Value: Equatable>(_ storage: inout Value, nonduplicate newValue: Value) {
    if storage != newValue { storage = newValue }
}
