//
//  Container.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-24.
//

// MARK: - Container

public protocol Container {
    
    // MARK: Requirements
    
    /// A Boolean value indicating whether the instance  is empty.
    @inlinable var empty: Bool { get }
}

// MARK: - Container: Details

public extension Container {
    
    // MARK: Getters
    
    /// A Boolean value indicating whether the instance  is nonempty.
    @inlinable var nonempty: Bool {
        !empty
    }
}
