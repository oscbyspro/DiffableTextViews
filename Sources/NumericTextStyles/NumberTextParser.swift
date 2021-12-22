//
//  NumberTextParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - NumberTextParser

public protocol NumberTextParser: TextParser where Output == NumberText {
    
    // MARK: Requirements
    
    associatedtype SignTextParser: TextParser = EmptyTextParser<SignText> where SignTextParser.Output == SignText
    @inlinable var sign: SignTextParser { get }
    
    associatedtype DigitsTextParser: TextParser = EmptyTextParser<DigitsText> where DigitsTextParser.Output == DigitsText
    @inlinable var digits: DigitsTextParser { get }
    
    associatedtype SeparatorTextParser: TextParser = EmptyTextParser<SeparatorText> where SeparatorTextParser.Output == SeparatorText
    @inlinable var separator: SeparatorTextParser { get }
}

// MARK: - NumberTextParser: Sign

public extension NumberTextParser where SignTextParser == EmptyTextParser<SignText> {
    
    // MARK: Implementation
    
    @inlinable @inline(__always) var sign: SignTextParser { .standard }
}

// MARK: - NumberTextParser: Digits

public extension NumberTextParser where DigitsTextParser == EmptyTextParser<DigitsText> {
    
    // MARK: Implementation
    
    @inlinable @inline(__always) var digits: DigitsTextParser { .standard }
}

// MARK: - NumberTextParser: Separator

public extension NumberTextParser where SeparatorTextParser == EmptyTextParser<SeparatorText> {
    
    // MARK: Implementation
    
    @inlinable @inline(__always) var separator: SeparatorTextParser { .standard }
}
