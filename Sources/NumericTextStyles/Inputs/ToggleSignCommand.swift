//
//  ToggleSignCommand.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-25.
//

import struct DiffableTextViews.Snapshot

// MARK: - ToggleSignCommand

@usableFromInline struct ToggleSignCommand {

    // MARK: Properties
    
    @usableFromInline private(set) var sign: Sign
    
    // MARK: Initializers
    
    @inlinable init?(consumable: inout Snapshot, parser: SignParser) {
        guard let sign = parser.parse(consumable.characters), !sign.isEmpty else { return nil }
        
        self.sign = sign
        consumable.removeAll()
    }
    
    // MARK: Utilities
            
    @inlinable func process(_ number: inout Number) {
        number.toggle(sign: sign)
    }
}
