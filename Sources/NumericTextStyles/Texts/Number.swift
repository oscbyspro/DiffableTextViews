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
    
    // MARK: Descriptions
    
    @inlinable var empty: Bool {
        sign.empty && integer.empty && separator.empty && fraction.empty
    }
    
    @inlinable var characters: String {
        sign.characters + integer.characters + separator.characters + fraction.characters
    }
        
    @inlinable func digitsCount() -> Count {
        .init(integer: integer.count, fraction: fraction.count)
    }
    
    // MARK: Transformations
    
    @inlinable mutating func toggle(sign proposal: Sign) {
        switch proposal {
        case .none: return
        case  sign: sign.removeAll()
        default:    sign = proposal
        }
    }
}
