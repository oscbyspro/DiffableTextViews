//
//  Text.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Text

#warning("WIP")
@usableFromInline protocol _Text {
    
    // MARK: Requirements
    
    associatedtype Parser: NumericTextStyles._Parser where Parser.Output == Self
    
    /// Creates an empty instance.
    @inlinable init()
    
    #warning("Currently unused.")
    /// A Boolean value indicating whether the text is empty.
    @inlinable var isEmpty: Bool { get }
    
    /// String representation of the instance.
    @inlinable var characters: String { get }
    
    /// Creates a parser configured to parse decimal numbers.
    @inlinable static var parser: Parser { get }
}

// MARK: - Utilities

extension _Text {
    
    // MARK: Initializers
    
    /// Creates an instance of this object or returns nil if the parsed characters don't represent an instance of this object.
    @inlinable init?<C: Collection>(characters: C, parser: Parser) where C.Element == Character {
        self.init(); var index = characters.startIndex
        parser.parse(characters: characters, index: &index, storage: &self)
        guard index == characters.endIndex else { return nil }
    }
}
