//
//  Attribute.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

// MARK: - Attribute

public enum Attribute: Equatable {
    
    /// The `content` attribute makes it so that the character `editable`.
    case content
    
    /// The `spacer` attribute makes it so that the character is `noneditable` and the `cursor skips over it.`
    case spacer
    
    /// The `prefix` attribute makes it so that the character is `noneditable` and the `cursor moves forwards from it.`
    case prefix
    
    /// The `suffix` attribute makes it so that the character is `noneditable` and  the `cursor moves backwards from it.`
    case suffix
}
