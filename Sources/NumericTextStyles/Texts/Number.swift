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
    
    @inlinable var isEmpty: Bool {
        sign.isEmpty && integer.isEmpty && separator.isEmpty && fraction.isEmpty
    }
    
    @inlinable var characters: String {
        sign.characters + integer.characters + separator.characters + fraction.characters
    }
        
    @inlinable func digitsCount() -> Number.DigitsCount {
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
    
    // MARK: Components
    
    @usableFromInline struct DigitsCount {

        // MARK: Properties

        @usableFromInline let integer:  Int
        @usableFromInline let fraction: Int

        // MARK: Initializers

        @inlinable init(integer: Int = 0, fraction: Int = 0) {
            self.integer  = integer
            self.fraction = fraction
        }

        // MARK: Getters

        @inlinable var total: Int {
            integer + fraction
        }
    }
}
