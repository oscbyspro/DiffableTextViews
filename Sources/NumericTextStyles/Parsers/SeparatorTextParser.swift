//
//  SeparatorTextParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

import struct Foundation.Locale

// MARK: - SeparatorTextParser

public struct SeparatorTextParser: TextParser {
    public typealias Output = SeparatorText

    // MARK: Properties
    
    @usableFromInline let separators: [String]
    
    // MARK: Initializers
    
    @inlinable init(separators: [String]) {
        self.separators = separators
    }
    
    // MARK: Transformations
    
    @inlinable public func locale(_ locale: Locale) -> SeparatorTextParser {
        .init(separators: separators + [locale.decimalSeparator].compactMap({ $0 }))
    }
    
    // MARK: Parse
    
    @inlinable public func parse<C: Collection>(characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character {
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
    
    public static let standard = Self(separators: [Output.dot])
}
