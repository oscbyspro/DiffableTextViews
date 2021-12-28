//
//  Text.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Text

/// A system representation of the conforming object.
@usableFromInline protocol Text {
    
    // MARK: Requirements
    
    /// Creates an empty instance.
    @inlinable init()
    
    /// A sytem representation of the instance.
    @inlinable var characters: String { get }    
}
