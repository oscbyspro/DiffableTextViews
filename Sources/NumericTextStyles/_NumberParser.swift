//
//  NumberTextParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - NumberTextParser

#warning("WIP")
public protocol _NumberParser: _Parser where Output == _NumberText {
    
    // MARK: Requirements
    
    associatedtype SignParser: _Parser = EmptyParser<_SignText> where SignParser.Output == _SignText
    @inlinable var sign: SignParser { get }
    
    associatedtype DigitsParser: _Parser = EmptyParser<_DigitsText> where DigitsParser.Output == _DigitsText
    @inlinable var digits: DigitsParser { get }
    
    associatedtype SeparatorParser: _Parser = EmptyParser<_SeparatorText> where SeparatorParser.Output == _SeparatorText
    @inlinable var separator: SeparatorParser { get }
}

// MARK: - NumberTextParser: Sign

public extension _NumberParser where SignParser == EmptyParser<_SignText> {
    
    // MARK: Implementation
    
    @inlinable @inline(__always) var sign: SignParser { .standard }
}

// MARK: - NumberTextParser: Digits

public extension _NumberParser where DigitsParser == EmptyParser<_DigitsText> {
    
    // MARK: Implementation
    
    @inlinable @inline(__always) var digits: DigitsParser { .standard }
}

// MARK: - NumberTextParser: Separator

public extension _NumberParser where SeparatorParser == EmptyParser<_SeparatorText> {
    
    // MARK: Implementation
    
    @inlinable @inline(__always) var separator: SeparatorParser { .standard }
}
