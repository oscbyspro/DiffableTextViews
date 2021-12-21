//
//  Text.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Text

#warning("WIP")
/// A system representation of the conforming object.
public protocol _Text {
    
    // MARK: Requirements
    
    /// Creates an empty instance.
    @inlinable init()
    
    /// A Boolean value indicating whether the instance  is empty.
    @inlinable var isEmpty: Bool { get }
    
    #warning("Should probably be a func since there is no O(1) guarantee.")
    /// A sytem representation of the instance.
    @inlinable var characters: String { get }
}

// MARK: - Utilities

extension _Text {
    
    // MARK: Initializers
    
    /// Creates an instance of this object or returns nil if the parsed characters don't represent an instance of this object.
    @inlinable init?<C: Collection, P: _Parser>(characters: C, parser: P) where C.Element == Character, P.Output == Self {
        self.init(); var index = characters.startIndex
        parser.parse(characters: characters, index: &index, storage: &self)
        guard index == characters.endIndex else { return nil }
    }
}
