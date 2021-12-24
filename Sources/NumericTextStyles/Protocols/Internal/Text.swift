//
//  Text.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

import protocol Utilities.Container

// MARK: - Text

/// A system representation of the conforming object.
@usableFromInline protocol Text: Container {
    
    // MARK: Requirements
    
    /// Creates an empty instance.
    @inlinable init()
    
    /// A sytem representation of the instance.
    @inlinable var characters: String { get }
}

// MARK: - Text: Details

extension Text {

    // MARK: Transformations
    
    /// Resets the instance to an empty state.
    @inlinable mutating func removeAll() {
        self = .init()
    }
}
