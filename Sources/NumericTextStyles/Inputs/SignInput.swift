//
//  SignInput.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-25.
//

import struct DiffableTextViews.Snapshot

// MARK: - SignInput

@usableFromInline struct SignInput {

    // MARK: Properties
    
    @usableFromInline private(set) var sign: Sign
    
    // MARK: Initializers
    
    @inlinable init?(consumable: inout Snapshot, parser: SignParser) {
        guard let first = consumable.characters.first else { return nil }
        guard let sign  = parser.translatables[first] else { return nil }
        
        self.sign = sign
        consumable.removeAll()
    }
    
    // MARK: Process
            
    @inlinable func process(_ number: inout Number) {
        number.sign = sign
    }
}
