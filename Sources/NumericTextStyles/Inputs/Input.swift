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
        
    // MARK: Initializers
            
    @inlinable init(_ content: Snapshot) {
        self.content = content
    }
    
    // MARK: Utilities
    
    @inlinable mutating func consumeSignInput(with parser: SignParser) -> SignInput? {
        .init(consumable: &content, parser: parser)
    }
}
