//
//  SeparatorParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

import struct Foundation.Locale

// MARK: - SeparatorParser

@usableFromInline struct SeparatorParser: Parser {

    // MARK: Properties
    
    @usableFromInline let translatables: Set<String>
    
    // MARK: Initializers
    
    @inlinable init(translatables: Set<String>) {
        self.translatables = translatables
    }
    
    // MARK: Transformations
    
    @inlinable func locale(_ locale: Locale) -> Self {
        .init(translatables: translatables.union([locale.decimalSeparator ?? Separator.dot]))
    }
    
    // MARK: Parse
    
    @inlinable func parse<C: Collection>(_ characters: C, index: inout C.Index, value: inout Separator) where C.Element == Character {
        let subsequence = characters[index...]
        for separator in translatables {
            if subsequence.starts(with: separator) {
                value.append(contentsOf: Separator.dot)
                characters.formIndex(&index, offsetBy: separator.count)
                return
            }
        }
    }
    
    // MARK: Instances
    
    @usableFromInline static let standard = Self(translatables: [Separator.dot])
}
