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
    
    case none = ""
    case positive = "+"
    case negative = "-"
    
    // MARK: Initializers
    
    @inlinable init() {
        self = .none
    }
        
    // MARK: Getters
    
    @inlinable @inline(__always) var isEmpty: Bool {
        rawValue.isEmpty
    }
    
    @inlinable @inline(__always) var characters: String {
        rawValue
    }
}

// MARK: - SignParser

#warning("WIP")
@usableFromInline struct _SignParser: _Parser {
    @usableFromInline typealias Output = _Sign

    // MARK: Properties
    
    @usableFromInline let positives: [String]
    @usableFromInline let negatives: [String]
    
    // MARK: Initializers
    
    @inlinable init(positives: [String], negatives: [String]) {
        self.positives = positives
        self.negatives = negatives
    }
    
    // MARK: Parse
    
    @inlinable func parse<C: Collection>(characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character {
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
    
    // MARK: Instances: Static
    
    @usableFromInline static let standard = Self(positives: [], negatives: [_Sign.negative.characters])
}
