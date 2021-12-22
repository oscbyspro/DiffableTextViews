//
//  Parsable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - Parsable

public protocol Parsable {
    
    // MARK: Requirements
        
    @inlinable static var parser: NumberParser { get }
}
