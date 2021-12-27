//
//  Cancellation.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-27.
//

// MARK: - Cancellation

public struct Cancellation: Error, CustomStringConvertible {
    
    // MARK: Properties
    
    public let reason: String
    
    // MARK: Initializers
    
    @inlinable public init(reason: String) {
        self.reason = reason
    }
    
    // MARK: Descriptions
    
    @inlinable public var description: String {
        reason
    }
}

// MARK: Cancellation: Error

public extension Error where Self == Cancellation {
    
    // MARK: Instances
    
    @inlinable static func cancellation(reason: String) -> Self {
        .init(reason: reason)
    }
}
