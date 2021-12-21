//
//  Float.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Float

#warning("WIP")
@usableFromInline struct _Float: _Text {
    
    // MARK: Properties
    
    @usableFromInline let sign: _Sign
    @usableFromInline let integer: _Digits
    @usableFromInline let separator: _Separator
    @usableFromInline let fraction: _Digits
    
    // MARK: Initializers
    
    @inlinable init() {
        self.sign = .init()
        self.integer = .init()
        self.separator = .init()
        self.fraction = .init()
    }
    
    // MARK: Getters
    
    @inlinable var characters: String {
        sign.characters + integer.characters + separator.characters + fraction.characters
    }
}

// MARK: - FloatingPointComponentsParser

#warning("WIP")
@usableFromInline struct _FloatParser { }
