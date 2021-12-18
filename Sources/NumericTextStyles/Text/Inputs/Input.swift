//
//  Input.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import struct DiffableTextViews.Snapshot

// MARK: - Input

@usableFromInline struct Input {
    
    // MARK: Properties
    
    @usableFromInline var content: Snapshot
    @usableFromInline var configuration: Configuration
        
    // MARK: Initializers
            
    @inlinable init(_ content: Snapshot, with configuration: Configuration) {
        self.content = content
        self.configuration = configuration
    }
    
    // MARK: Utilities
    
    @inlinable mutating func consumeToggleSignInstruction() -> ToggleSignInstruction? {
        .init(consumable: &content, with: configuration)
    }
}
