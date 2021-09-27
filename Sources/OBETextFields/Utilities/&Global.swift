//
//  &Global.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

/// Updates storage only if the new value is different.
///
@inlinable func updateLazily<Value: Equatable>(_ storage: inout Value, with newValue: Value) {
    if storage != newValue {
        storage = newValue
    }
}
