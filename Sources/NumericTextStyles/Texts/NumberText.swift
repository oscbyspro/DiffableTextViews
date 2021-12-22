//
//  NumberText.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - NumberText

#warning("WIP")
#warning("Rename as NumberText, maybe.")
public struct NumberText: Text {
    
    // MARK: Properties
    
    @usableFromInline var sign: SignText
    @usableFromInline var integer: DigitsText
    @usableFromInline var separator: SeparatorText
    @usableFromInline var fraction: DigitsText
    
    // MARK: Initializers
    
    @inlinable public init() {
        self.sign = .init()
        self.integer = .init()
        self.separator = .init()
        self.fraction = .init()
    }
    
    // MARK: Getters
 
    @inlinable public var isEmpty: Bool {
        sign.isEmpty && integer.isEmpty && separator.isEmpty && fraction.isEmpty
    }
    
    @inlinable public var characters: String {
        sign.characters + integer.characters + separator.characters + fraction.characters
    }
    
    // MARK: Transformations
    
    @inlinable mutating func toggle(sign proposal: SignText) {
        if sign == proposal { sign = .none } else { sign = proposal }
    }
    
    // MARK: Utilities
    
    @inlinable var numberOfDigits: Count {
        .init(integer: integer.count, fraction: fraction.count)
    }
    
    @inlinable func numberOfSignificantDigits() -> Count {
        let integerValue = integer.count - numberOfRedundantIntegerDigits()
        let fractionValue = fraction.count - numberOfRedundantFractionDigits()
        return .init(integer: integerValue, fraction: fractionValue)
    }
    
    // MARK: Utilities: Helpers
        
    @inlinable func numberOfRedundantIntegerDigits() -> Int {
        integer.characters.prefix(while: { $0 == DigitsText.zero }).count
    }
    
    @inlinable func numberOfRedundantFractionDigits() -> Int {
        fraction.characters.reversed().prefix(while: { $0 == DigitsText.zero }).count
    }
}
