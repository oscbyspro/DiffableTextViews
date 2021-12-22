//
//  Input.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import struct DiffableTextViews.Snapshot

// MARK: - Input

@usableFromInline struct Input<Parser: NumberTextParser> {
    
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

    // MARK: Properties
    
    @usableFromInline var sign: SignText
    
    // MARK: Initializers
    
    @inlinable init?<P: TextParser>(consumable: inout Snapshot, parser: P) where P.Output == SignText {
        guard let sign = SignText(characters: consumable.characters, parser: parser) else { return nil }
                                        
        self.sign = sign
        consumable.removeAll()
    }
    
    // MARK: Utilities
            
    @inlinable func process(_ number: inout NumberText) {
        number.toggle(sign: sign)
    }
}
