//
//  SignTextParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - SignTextParser

#warning("WIP")
public struct SignTextParser: TextParser {
    public typealias Output = SignText

    // MARK: Properties
    
    @usableFromInline let positives: [String]
    @usableFromInline let negatives: [String]
    
    // MARK: Initializers
    
    @inlinable init(positives: [String], negatives: [String]) {
        self.positives = positives
        self.negatives = negatives
    }
    
    // MARK: Parse
    
    @inlinable public func parse<C: Collection>(characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character {
        let subsequence = characters[index...]
        
        func parse(_ signs: [String], success: Output) -> Bool {
            for sign in signs {
                if subsequence.starts(with: sign) {
                    storage = success
                    characters.formIndex(&index, offsetBy: sign.count)
                    return true
                }
            }
            
            return false
        }
        
        if parse(negatives, success: .negative) { return }
        if parse(positives, success: .positive) { return }
    }
    
    // MARK: Instances
    
    public static let standard = Self(positives: [], negatives: [Output.negative.characters])
}

