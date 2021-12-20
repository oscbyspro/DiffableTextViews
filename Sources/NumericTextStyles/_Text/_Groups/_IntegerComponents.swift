//
//  IntegerComponents.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - IntegerComponents

#warning("WIP")
@usableFromInline struct _IntegerComponents: _Components {
    
    // MARK: Properties
    
    @usableFromInline let sign: _Sign
    @usableFromInline let digits: _Digits
    
    // MARK: Getters
    
    @inlinable var characters: String {
        sign.characters + digits.characters
    }
}
