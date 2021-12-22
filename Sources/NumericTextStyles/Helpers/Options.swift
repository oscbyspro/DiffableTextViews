//
//  Options.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - Options

@usableFromInline struct Options: OptionSet {
    
    // MARK: Properties
    
    @usableFromInline var rawValue: UInt8
    
    // MARK: Initializers
    
    @inlinable init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    
    // MARK: Instances
    
    @usableFromInline static let unsigned = Self(rawValue: 1 << 0)
    @usableFromInline static let integer  = Self(rawValue: 1 << 1)
}
