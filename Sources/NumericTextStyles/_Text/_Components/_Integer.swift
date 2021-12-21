//
//  Integer.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Integer

#warning("WIP")
@usableFromInline struct _Integer: _Text {

    // MARK: Properties
    
    @usableFromInline let sign: _Sign
    @usableFromInline let digits: _Digits
    
    // MARK: Initializers
    
    @inlinable init() {
        self.sign = .init()
        self.digits = .init()
    }
    
    // MARK: Getters
    
    @inlinable var characters: String {
        sign.characters + digits.characters
    }
}

// MARK: - IntegerParser

#warning("WIP")
@usableFromInline struct _IntegerParser { }
