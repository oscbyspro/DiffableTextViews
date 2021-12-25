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
    @usableFromInline let parser: NumberParser
        
    // MARK: Initializers
            
    @inlinable init(_ content: Snapshot, parser: NumberParser) {
        self.content = content
        self.parser = parser
    }
    
    // MARK: Utilities
    
    @inlinable mutating func consumeToggleSignCommand() -> ToggleSignCommand? {
        .init(consumable: &content, parser: parser.sign)
    }
}
