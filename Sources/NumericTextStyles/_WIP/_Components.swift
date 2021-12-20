//
//  Components.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Components

#warning("WIP")
@usableFromInline protocol _Components { }

// MARK: - IntegerComponents

#warning("WIP")
@usableFromInline struct _IntegerComponents: _Components {
    
    // MARK: Properties
    
    @usableFromInline let sign: _Sign?
    @usableFromInline let digits: _Digits?
}

// MARK: - FloatingPointComponents

#warning("WIP")
@usableFromInline struct _FloatingPointComponents: _Components {
    
    // MARK: Properties
    
    @usableFromInline let sign: _Sign?
    @usableFromInline let integer: _Digits?
    @usableFromInline let separator: _Separator?
    @usableFromInline let fraction: _Digits?
}
