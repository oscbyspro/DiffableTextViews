//
//  Input.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import DiffableTextViews

// MARK: - Input

@usableFromInline struct Input {
    @usableFromInline typealias Command = (inout Number) -> Void
    
    // MARK: Properties
    
    @usableFromInline var content: Snapshot
    @usableFromInline var process: Command?
        
    // MARK: Initializers
            
    @inlinable init(_ content: Snapshot) {
        self.content = content
    }
    
    // MARK: Utilities
    
    @inlinable mutating func consumeSignInput(with parser: SignParser) {
        guard let first = content.characters.first   else { return }
        guard let sign = parser.translatables[first] else { return }

        // --------------------------------- //
        // MARK: Set Sign Command Found
        // --------------------------------- //
        
        self.content.removeAll()
        self.process = { number in number.sign = sign }
    }
}
