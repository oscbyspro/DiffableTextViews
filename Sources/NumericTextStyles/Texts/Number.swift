//
//  Number.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Number

/// Representation of a system number.
///
/// - Upper refers to integer digits.
/// - Lower refers to fraction digits.
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
    
    @inlinable var isEmpty: Bool {
        sign.isEmpty && integer.isEmpty && separator.isEmpty && fraction.isEmpty
    }
    
    @inlinable var characters: String {
        sign.characters + integer.characters + separator.characters + fraction.characters
    }
        
    @inlinable func significantCount() -> Int {
        let significantIntegerCount = integer.count - integer.countZerosInPrefix()
        let significantFractionCount = fraction.count - fraction.countZerosInSuffix()
        return significantIntegerCount + significantFractionCount
    }
    
    // MARK: Command
    
    @inlinable mutating func toggle(sign proposal: Sign) {
        switch proposal {
        case .none: return
        case  sign: sign.removeAll()
        default:    sign = proposal
        }
    }
    
    // MARK: Correct

    #warning("WIP")
    @inlinable mutating func autocorrectSign<Value: Boundable>(bounds: Bounds<Value>) {
        if bounds.nonpositive {
            sign = .negative
        } else if sign == .negative, .zero <= bounds.lowerBound {
            sign = .none
        }
    }
    
    #warning("WIP")
    @inlinable mutating func autocorrectSeparator(capacity: Capacity) {
        if fraction.isEmpty, capacity.fraction <= .zero { separator.removeAll() }
    }
}
