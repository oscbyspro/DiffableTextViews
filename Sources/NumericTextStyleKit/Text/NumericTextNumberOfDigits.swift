//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

// MARK: - NumericTextNumberOfDigits

@usableFromInline struct NumericTextNumberOfDigits {
    
    // MARK: Properties
    
    @usableFromInline let upper: Int
    @usableFromInline let lower: Int
    
    // MARK: Initializers
    
    @inlinable init(upper: Int = 0, lower: Int = 0) {
        self.upper = upper
        self.lower = lower
    }
}
