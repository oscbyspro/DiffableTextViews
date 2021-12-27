//
//  Capacity.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-24.
//

// MARK: - Capacity

@usableFromInline struct Capacity {

    // MARK: Properties

    @usableFromInline let value: Int
    @usableFromInline let upper: Int
    @usableFromInline let lower: Int

    // MARK: Initializers

    @inlinable init(value: Int, upper: Int, lower: Int) {
        self.value = value
        self.upper = upper
        self.lower = lower
    }
}
