//
//  Component.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Component

#warning("WIP")

@usableFromInline protocol Component {
    
    // MARK: Requirements
    
    /// Instantiates an empty instance.
    @inlinable init()
    
    /// String representation of the instance.
    @inlinable var characters: String { get }
}
