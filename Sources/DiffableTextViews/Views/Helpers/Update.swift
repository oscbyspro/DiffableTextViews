//
//  Update.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-05.
//

// MARK: - Update

@usableFromInline struct Update: OptionSet {
    @usableFromInline static var upstream:   Self = .init(rawValue: 1 << 0)
    @usableFromInline static var downstream: Self = .init(rawValue: 1 << 1)

    // MARK: Properties
    
    @usableFromInline let rawValue: UInt8
    
    // MARK: Initializers
    
    @inlinable init(rawValue: UInt8 = 0) {
        self.rawValue = rawValue
    }
}

