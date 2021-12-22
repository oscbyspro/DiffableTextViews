//
//  SeparatorParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

import struct Foundation.Locale

// MARK: - SeparatorParser

@usableFromInline struct SeparatorParser: Parser {
    @usableFromInline typealias Output = Separator

    // MARK: Properties
    
    @usableFromInline let separators: [String]
    
    // MARK: Initializers
    
    @inlinable init(separators: [String]) {
        self.separators = separators
    }
    
    // MARK: Transformations
    
    @inlinable func locale(_ locale: Locale) -> SeparatorParser {
        .init(separators: separators + [locale.decimalSeparator].compactMap({ $0 }))
    }
    
    // MARK: Parse
    
    @inlinable func parse<C: Collection>(characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character {
        let subsequence = characters[index...]
        
        for separator in separators {
            if subsequence.starts(with: separator) {
                storage = Output(characters: Output.dot)
                characters.formIndex(&index, offsetBy: separator.count)
                return
            }
        }
    }
    
    // MARK: Instances
    
    @usableFromInline static let standard = Self(separators: [Output.dot])
}
