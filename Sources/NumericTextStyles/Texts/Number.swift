//
//  Number.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Number

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
        
    @inlinable var digitsCount: NumberDigitsCount {
        .init(integer: integer.count, fraction: fraction.count)
    }
    
    // MARK: Transformations

    #warning("WIP")
    @inlinable mutating func autocorrectSign<Value: Boundable>(bounds: Bounds<Value>) {
        if bounds.nonpositive {
            sign = .negative
        } else if sign == .negative, .zero <= bounds.lowerBound {
            sign = .none
        }
    }
    
    #warning("WIP")
    @inlinable mutating func autocorrectSeparator(capacity: NumberDigitsCount) {
        if fraction.isEmpty, capacity.fraction <= .zero { separator.removeAll() }
    }
    
    // MARK: Transformations: Commands
    
    @inlinable mutating func toggle(sign proposal: Sign) {
        switch proposal {
        case .none: return
        case  sign: sign.removeAll()
        default:    sign = proposal
        }
    }
}
