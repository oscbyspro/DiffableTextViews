//
//  ToggleSignInstruction.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import struct DiffableTextViews.Snapshot

// MARK: - ToggleSignInstruction

#warning("Needs rework or be removed.")
#warning("Rename: ToggleSignInput, maybe.")
@usableFromInline struct ToggleSignInstruction {

    // MARK: Properties
    
    @usableFromInline var sign: Components.Sign
    
    // MARK: Initializers
            
    @inlinable init?(consumable: inout Snapshot, with configuration: Configuration) {
        guard let sign = configuration.signs.interpret(consumable.characters) else { return nil }
                                        
        self.sign = sign
        consumable.removeAll()
    }
    
    // MARK: Utilities
            
    @inlinable func process(_ components: inout Components) {
        components.toggleSign(with: sign)
    }
}
