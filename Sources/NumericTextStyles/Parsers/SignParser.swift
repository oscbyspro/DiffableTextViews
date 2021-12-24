//
//  SignParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - SignParser

#warning("Use a dictionary instead.")
@usableFromInline struct SignParser: Parser {

    // MARK: Properties
    
    @usableFromInline let positives: [String]
    @usableFromInline let negatives: [String]
    
    // MARK: Initializers
    
    @inlinable init(positives: [String], negatives: [String]) {
        self.positives = positives
        self.negatives = negatives
    }
    
    // MARK: Parse
    
    @inlinable func parse<C: Collection>(_ characters: C, index: inout C.Index, value: inout Sign) where C.Element == Character {
        let subsequence = characters[index...]
        
        func parse(_ signs: [String], success: Sign) -> Bool {
            for sign in signs {
                if subsequence.starts(with: sign) {
                    value = success
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
    
    @usableFromInline static let standard = Self(positives: [], negatives: [Value.negative.characters])
}

