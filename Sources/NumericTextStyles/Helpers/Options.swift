//
//  Options.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - Options

#warning("Rename/move to NumberParser, maybe.")
@usableFromInline struct Options: OptionSet {
    
    // MARK: Properties
    
    @usableFromInline var rawValue: UInt8
    
    // MARK: Initializers
    
    @inlinable init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    
    // MARK: Instances: Singular
    
    @usableFromInline static let unsigned = Self(rawValue: 1 << 0)
    @usableFromInline static let integer  = Self(rawValue: 1 << 1)
    
    // MARK: Instances: Composites
    
    @usableFromInline static let unsignedInteger = Self([.unsigned, .integer])
}
