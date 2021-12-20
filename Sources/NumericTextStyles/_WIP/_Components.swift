//
//  Components.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

#warning("Replace: Sign, Digits, Separator.")

// MARK: - Components

#warning("WIP")
@usableFromInline protocol _Components { }

// MARK: - IntegerComponents

#warning("WIP")
@usableFromInline struct IntegerComponents: _Components {
    
    // MARK: Properties
    
    @usableFromInline let sign: _Sign?
    @usableFromInline let digits: _Digits?
}

// MARK: - FloatingPointComponents

#warning("WIP")
@usableFromInline struct FloatingPointComponents: _Components {
    
    // MARK: Properties
    
    @usableFromInline let sign: _Sign?
    @usableFromInline let integer: _Digits?
    @usableFromInline let separator: _Separator?
    @usableFromInline let fraction: _Digits?
}
