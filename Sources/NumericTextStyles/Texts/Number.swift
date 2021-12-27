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
    @usableFromInline var upper = Digits()
    @usableFromInline var separator = Separator()
    @usableFromInline var lower = Digits()
    
    // MARK: Initializers
    
    @inlinable init() { }
    
    // MARK: Descriptions
    
    @inlinable var isEmpty: Bool {
        sign.isEmpty && upper.isEmpty && separator.isEmpty && lower.isEmpty
    }
    
    @inlinable var characters: String {
        sign.characters + upper.characters + separator.characters + lower.characters
    }
    
    // MARK: Count
    
    @inlinable func valueCount() -> Int {
        let upperCount = upper.count - upper.countZerosInPrefix()
        let lowerCount = lower.count - lower.countZerosInSuffix()
        
        return upperCount + lowerCount
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
        if lower.isEmpty, capacity.lower <= .zero { separator.removeAll() }
    }
    
    // MARK: Command
    
    @inlinable mutating func toggle(sign proposal: Sign) {
        switch proposal {
        case .none: return
        case  sign: sign.removeAll()
        default:    sign = proposal
        }
    }
}
