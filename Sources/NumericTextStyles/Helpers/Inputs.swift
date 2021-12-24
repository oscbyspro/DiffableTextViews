//
//  Input.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import struct DiffableTextViews.Snapshot

// MARK: - Input

@usableFromInline struct Input {
    @usableFromInline typealias Parser = NumberParser
    
    // MARK: Properties
    
    @usableFromInline var content: Snapshot
    @usableFromInline let parser: Parser
        
    // MARK: Initializers
            
    @inlinable init(_ content: Snapshot, parser: Parser) {
        self.content = content
        self.parser = parser
    }
    
    // MARK: Utilities
    
    @inlinable mutating func consumeToggleSignInput() -> ToggleSignInput? {
        .init(consumable: &content, parser: parser.sign)
    }
}

// MARK: - ToggleSignInput

@usableFromInline struct ToggleSignInput {
    @usableFromInline typealias Parser = SignParser

    // MARK: Properties
    
    @usableFromInline var sign: Sign
    
    // MARK: Initializers
    
    @inlinable init?(consumable: inout Snapshot, parser: Parser) {
        guard let sign = parser.parse(consumable.characters), sign.nonempty else { return nil }
        
        self.sign = sign
        consumable.removeAll()
    }
    
    // MARK: Utilities
            
    @inlinable func process(_ number: inout Number) {
        number.toggle(sign: sign)
    }
}
