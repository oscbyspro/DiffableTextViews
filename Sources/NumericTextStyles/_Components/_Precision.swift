//
//  Precision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Precision

#warning("WIP")
public struct _Precision<Value: Precise> {
    
    // MARK: Properties
    
    @usableFromInline let integer: Int
    @usableFromInline let fraction: Int
    
    // MARK: Initializers
    
    @inlinable init(integer: Int, fraction: Int) {
        self.integer = integer
        self.fraction = fraction
    }
}
