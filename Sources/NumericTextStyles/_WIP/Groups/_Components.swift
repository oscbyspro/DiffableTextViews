//
//  Components.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Components

#warning("WIP")
@usableFromInline protocol _Components {
    
    // MARK: Requirements
    
    var characters: String { get }
}

// MARK: - ParsableComponents

#warning("WIP")
@usableFromInline protocol _ParsableComponents: _Components {
    
    // MARK: Requirements
    
    associatedtype Parser: NumericTextStyles._Parser
    
    init<C: Collection>(_ collection: C, parser: Parser) where C.Element == Character
}
