//
//  Reason.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-27.
//

// MARK: - Reason

public struct Reason: Error, CustomStringConvertible {
    
    // MARK: Properties
    
    public let description: String
    
    // MARK: Initializers
    
    @inlinable public init(_ description: String) {
        self.description = description
    }
}

// MARK: - Reason: Error

public extension Error where Self == Reason {
    
    // MARK: Standard
    
    @inlinable static func reason(_ description: String) -> Self {
        .init(description)
    }
    
    // MARK: Relation
    
    @inlinable static func reason(_ first: Any, _ relation: StaticString) -> Self {
        .init("« \(String(describing: first)) » \(relation)")
    }
    
    @inlinable static func reason(_ relation: StaticString, _ last: Any) -> Self {
        .init("\(relation) « \(String(describing: last)) »")
    }
    
    @inlinable static func reason(_ first: Any, _ relation: StaticString, _ last: Any) -> Self {
        .init("« \(String(describing: first)) » \(relation) « \(String(describing: last)) »")
    }
}
