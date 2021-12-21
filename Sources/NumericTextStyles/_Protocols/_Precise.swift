//
//  Precise.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Precise

#warning("WIP")
public protocol _Precise {
    
    // MARK: Requirements
    
    #warning("This is the only requirement needed, the rest can be done with affordance protocols.")
    @inlinable static var maxLosslessDigits: Int { get }
}
