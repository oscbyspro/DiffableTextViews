//
//  Count.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

// MARK: - Count

#warning("Rename as NumberDigitsCount, maybe.")
@usableFromInline struct Count {
    
    // MARK: Properties
    
    @usableFromInline let integer:  Int
    @usableFromInline let fraction: Int
    
    // MARK: Initializers
    
    @inlinable init(integer: Int = 0, fraction: Int = 0) {
        self.integer  = integer
        self.fraction = fraction
    }
    
    // MARK: Getters
    
    @inlinable var total: Int {
        integer + fraction
    }
}
