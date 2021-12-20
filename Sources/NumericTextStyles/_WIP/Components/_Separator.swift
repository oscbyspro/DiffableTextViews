//
//  Separator.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Separator

#warning("WIP")
@usableFromInline struct _Separator: Component {
    
    // MARK: Properties
    
    @usableFromInline let characters: String
    
    // MARK: Initializers
    
    @inlinable init() {
        self.characters = ""
    }
}

// MARK: - ParseableSeparators

#warning("WIP")
@usableFromInline struct _ParsableSeparatos {
    
    // MARK: Properties
    
    @usableFromInline let separators: [String]
}
