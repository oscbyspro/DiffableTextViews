//
//  Number.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

#warning("Make sure that integer is never empty.")

// MARK: - Number

/// A representation of a system number.
///
/// - Integer component is never empty.
///
@usableFromInline struct Number: Text {
    
    // MARK: Properties
    
    @usableFromInline var sign = Sign()
    @usableFromInline var integer = Digits()
    @usableFromInline var separator = Separator()
    @usableFromInline var fraction = Digits()
    
    // MARK: Initializers
    
    @inlinable init() { }
    
    // MARK: Descriptions
    
    #warning("Text should have a characters() func requirement to show O(n) possibility.")
    @inlinable var characters: String {
        sign.characters + integer.characters + separator.characters + fraction.characters
    }
    
    // MARK: Count
        
    @inlinable func significantCount() -> Int {
        let significantIntegerCount = integer.count - integer.prefixZerosCount()
        let significantFractionCount = fraction.count - fraction.suffixZerosCount()
        return significantIntegerCount + significantFractionCount
    }
    
    // MARK: Transformations
    
    @inlinable mutating func removeImpossibleSeparator(capacity: Capacity) {
        guard fraction.isEmpty else { return }
        guard capacity.fraction <= 0 || capacity.significant <= 0 else { return }
        separator = Separator()
    }
}
