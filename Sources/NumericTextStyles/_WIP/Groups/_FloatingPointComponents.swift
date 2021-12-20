//
//  FloatingPointComponents.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - FloatingPointComponents

#warning("WIP")
@usableFromInline struct _FloatingPointComponents: _Components {
    
    // MARK: Properties
    
    @usableFromInline let sign: _Sign
    @usableFromInline let integer: _Digits
    @usableFromInline let separator: _Separator
    @usableFromInline let fraction: _Digits
    
    // MARK: Getters
    
    @inlinable var characters: String {
        sign.characters + integer.characters + separator.characters + fraction.characters
    }
}
