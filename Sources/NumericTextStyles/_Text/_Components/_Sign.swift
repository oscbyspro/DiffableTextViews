//
//  Sign.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Sign

#warning("WIP")
@usableFromInline enum _Sign: String, _Text {
    
    // MARK: Cases
    
    case positive = "+"
    case negative = "-"
    case none = ""
    
    // MARK: Initializers
    
    @inlinable init() {
        self = .none
    }
    
    // MARK: Getters
    
    @inlinable @inline(__always) var characters: String {
        rawValue
    }
}

// MARK: - SignParser

#warning("WIP")
@usableFromInline struct _SignParser: _Parser {
    
    // MARK: Properties
    
    @usableFromInline let positives: [String]
    @usableFromInline let negatives: [String]
    
    // MARK: Initializers
    
    @inlinable init(positives: [String], negatives: [String]) {
        self.positives = positives
        self.negatives = negatives
    }
    
    // MARK: Parse
    
    @inlinable func parse<C: Collection>(_ characters: C, from index: inout C.Index, into storage: inout _Sign) where C.Element == Character {
        let subsequence = characters[index...]
                
        func parse(_ signs: [String], success: _Sign) -> Bool {
            for sign in signs {
                guard subsequence.starts(with: sign) else { continue }
                
                storage = success
                characters.formIndex(&index, offsetBy: sign.count)
                return true
            }
            
            return false
        }
        
        if parse(negatives, success: .negative) { return }
        if parse(positives, success: .positive) { return }
    }
    
    // MARK: Instances: Static
    
    @usableFromInline static let all = Self(
        positives: [_Sign.positive.characters],
        negatives: [_Sign.negative.characters])
    
    @usableFromInline static let positives = Self(
        positives: [_Sign.positive.characters],
        negatives: [])
    
    @usableFromInline static let negatives = Self(
        positives: [],
        negatives: [_Sign.negative.characters])
}
