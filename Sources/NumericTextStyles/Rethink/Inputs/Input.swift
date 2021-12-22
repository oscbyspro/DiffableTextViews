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
    
    @inlinable mutating func consumeToggleSignInput() -> ToggleSignInput? {
        .init(consumable: &content)
    }
}

// MARK: - ToggleSignInput

@usableFromInline struct ToggleSignInput {

    // MARK: Properties
    
    @usableFromInline var sign: _Sign
    
    // MARK: Initializers
    
    #warning("WIP.")
    @inlinable init?<P: _Parser>(consumable: inout Snapshot, parser: P) {
        guard let sign = _Sign(characters: consumable.characters, parser: parser) else { return nil }
                                        
        self.sign = sign
        consumable.removeAll()
    }
    
    // MARK: Utilities
            
    @inlinable func process(_ number: inout _Number) {
        number.toggle(sign: sign)
    }
}
