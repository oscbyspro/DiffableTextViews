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
    
    // MARK: Initializers: Static
    
    @inlinable static func max<Value: Precise>(
        in type: Value.Type = Value.self,
        integer: Int = Value.maxLosslessIntegerDigits,
        fraction: Int = Value.maxLosslessFractionDigits,
        significant: Int = Value.maxLosslessSignificantDigits
    ) -> Self {
        .init(integer: integer, fraction: fraction, significant: significant)
    }
}
