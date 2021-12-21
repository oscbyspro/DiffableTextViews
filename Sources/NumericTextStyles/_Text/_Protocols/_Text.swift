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
