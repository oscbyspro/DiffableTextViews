//
//  Utilities.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

/// Updates storage only if the new value is different.
///
/// - Complexity: O(1).
@inlinable func updateLazily<T: Equatable>(_ storage: inout T, with newValue: T) {
    if storage != newValue {
        storage = newValue
    }
}
