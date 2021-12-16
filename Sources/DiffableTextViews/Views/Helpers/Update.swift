//
//  Update.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-05.
//

// MARK: - Update

@usableFromInline struct Update: OptionSet {
    @usableFromInline static let async = Self(rawValue: 1 << 0)
    @usableFromInline static let upstream = Self(rawValue: 1 << 1)
    @usableFromInline static let downstream = Self(rawValue: 1 << 2)

    // MARK: Properties
    
    @usableFromInline let rawValue: UInt8
    
    // MARK: Initializers
    
    @inlinable init(rawValue: UInt8 = 0) {
        self.rawValue = rawValue
    }
}
