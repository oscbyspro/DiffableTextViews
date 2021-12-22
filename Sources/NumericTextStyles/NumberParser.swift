//
//  NumberTextParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - NumberTextParser

#warning("WIP")
public protocol NumberParser: Parser where Output == NumberText {
    
    // MARK: Requirements
    
    associatedtype SignParser: Parser = EmptyParser<SignText> where SignParser.Output == SignText
    @inlinable var sign: SignParser { get }
    
    associatedtype DigitsParser: Parser = EmptyParser<DigitsText> where DigitsParser.Output == DigitsText
    @inlinable var digits: DigitsParser { get }
    
    associatedtype SeparatorParser: Parser = EmptyParser<SeparatorText> where SeparatorParser.Output == SeparatorText
    @inlinable var separator: SeparatorParser { get }
}

// MARK: - NumberTextParser: Sign

public extension NumberParser where SignParser == EmptyParser<SignText> {
    
    // MARK: Implementation
    
    @inlinable @inline(__always) var sign: SignParser { .standard }
}

// MARK: - NumberTextParser: Digits

public extension NumberParser where DigitsParser == EmptyParser<DigitsText> {
    
    // MARK: Implementation
    
    @inlinable @inline(__always) var digits: DigitsParser { .standard }
}

// MARK: - NumberTextParser: Separator

public extension NumberParser where SeparatorParser == EmptyParser<SeparatorText> {
    
    // MARK: Implementation
    
    @inlinable @inline(__always) var separator: SeparatorParser { .standard }
}
