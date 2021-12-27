//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-26.
//

// MARK: - Failure

public struct Failure: Error {
    
    // MARK: Initializers
    
    @inlinable init() { }
}

// MARK: - Failure: Error

public extension Error where Self == Failure {
    
    // MARK: Instances
    
    @inlinable static var failure: Failure {
        .init()
    }
}

// MARK: - Failure: Optional

public extension Optional {
    
    // MARK: Utilities
    
    @inlinable func get() throws -> Wrapped {
        switch self {
        case .some(let wrapped): return wrapped
        case .none:              throw .failure
        }
    }
}

public extension Bool {
    
    // MARK: Utilities
    
    @inlinable func `true`() throws {
        switch self {
        case  true: return
        case false: throw .failure
        }
    }
    
    @inlinable func `false`() throws {
        switch self {
        case false: return
        case  true: throw .failure
        }
    }
}
