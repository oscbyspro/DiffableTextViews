//
//  Capacity.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-24.
//

// MARK: - Capacity

@usableFromInline struct Capacity {

    // MARK: Properties

    @usableFromInline let integer: Int
    @usableFromInline let fraction: Int
    @usableFromInline let significant: Int

    // MARK: Initializers

    @inlinable init(integer: Int, fraction: Int, significant: Int) {
        self.integer = integer
        self.fraction = fraction
        self.significant = significant
    }
}
