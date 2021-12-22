//
//  NumberTextParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - NumberTextParser

#warning("WIP")
public protocol _NumberTextParser: _Parser where Output == _Number {
    
    // MARK: Requirements
    
    associatedtype SignParser: _Parser = EmptyParser<_Sign> where SignParser.Output == _Sign
    @inlinable var sign: SignParser { get }
    
    associatedtype DigitsParser: _Parser = EmptyParser<_Digits> where DigitsParser.Output == _Digits
    @inlinable var digits: DigitsParser { get }
    
    associatedtype SeparatorParser: _Parser = EmptyParser<_Separator> where SeparatorParser.Output == _Separator
    @inlinable var separator: SeparatorParser { get }
}

// MARK: - NumberTextParser: Sign

public extension _NumberTextParser where SignParser == EmptyParser<_Sign> {
    
    // MARK: Implementation
    
    @inlinable @inline(__always) var sign: SignParser { .standard }
}

// MARK: - NumberTextParser: Digits

public extension _NumberTextParser where DigitsParser == EmptyParser<_Digits> {
    
    // MARK: Implementation
    
    @inlinable @inline(__always) var sign: SignParser { .standard }
}

// MARK: - NumberTextParser: Separator

public extension _NumberTextParser where SeparatorParser == EmptyParser<_Separator> {
    
    // MARK: Implementation
    
    @inlinable @inline(__always) var sign: SignParser { .standard }
}
