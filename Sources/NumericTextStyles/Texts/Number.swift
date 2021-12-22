//
//  Number.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Number

@usableFromInline struct Number: Text {
    
    // MARK: Properties
    
    @usableFromInline var sign: Sign
    @usableFromInline var integer: Digits
    @usableFromInline var separator: Separator
    @usableFromInline var fraction: Digits
    
    // MARK: Initializers
    
    @inlinable init() {
        self.sign = .init()
        self.integer = .init()
        self.separator = .init()
        self.fraction = .init()
    }
    
    // MARK: Getters
 
    @inlinable var isEmpty: Bool {
        sign.isEmpty && integer.isEmpty && separator.isEmpty && fraction.isEmpty
    }
    
    @inlinable var characters: String {
        sign.characters + integer.characters + separator.characters + fraction.characters
    }
    
    // MARK: Transformations
    
    @inlinable mutating func toggle(sign proposal: Sign) {
        if sign == proposal { sign = .none } else { sign = proposal }
    }
    
    // MARK: Counts
    
    @inlinable func numberOfDigits() -> Count {
        .init(integer: integer.count, fraction: fraction.count)
    }
    
    @inlinable func numberOfSignificantDigits() -> Count {
        let integerValue = integer.count - numberOfRedundantIntegerDigits()
        let fractionValue = fraction.count - numberOfRedundantFractionDigits()
        return .init(integer: integerValue, fraction: fractionValue)
    }
        
    @inlinable func numberOfRedundantIntegerDigits() -> Int {
        integer.characters.prefix(while: { $0 == Digits.zero }).count
    }
    
    @inlinable func numberOfRedundantFractionDigits() -> Int {
        fraction.characters.reversed().prefix(while: { $0 == Digits.zero }).count
    }
}
