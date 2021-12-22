//
//  NumberTextParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - NumberTextParser

public protocol NumberTextParser: TextParser where Output == NumberText {
    
    // MARK: Requirements
    
    associatedtype SignParser: TextParser = EmptyTextParser<SignText> where SignParser.Output == SignText
    @inlinable var sign: SignParser { get }
    
    associatedtype DigitsParser: TextParser = EmptyTextParser<DigitsText> where DigitsParser.Output == DigitsText
    @inlinable var digits: DigitsParser { get }
    
    associatedtype SeparatorParser: TextParser = EmptyTextParser<SeparatorText> where SeparatorParser.Output == SeparatorText
    @inlinable var separator: SeparatorParser { get }
}

// MARK: - NumberTextParser: Sign

public extension NumberTextParser where SignParser == EmptyTextParser<SignText> {
    
    // MARK: Implementation
    
    @inlinable @inline(__always) var sign: SignParser { .standard }
}

// MARK: - NumberTextParser: Digits

public extension NumberTextParser where DigitsParser == EmptyTextParser<DigitsText> {
    
    // MARK: Implementation
    
    @inlinable @inline(__always) var digits: DigitsParser { .standard }
}

// MARK: - NumberTextParser: Separator

public extension NumberTextParser where SeparatorParser == EmptyTextParser<SeparatorText> {
    
    // MARK: Implementation
    
    @inlinable @inline(__always) var separator: SeparatorParser { .standard }
}
