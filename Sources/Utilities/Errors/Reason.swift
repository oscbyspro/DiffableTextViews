//
//  Reason.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-27.
//

// MARK: - Reason

/// An error that contains a description in DEBUG mode, but is empty in RELEASE mode.
public struct Reason: Error, CustomStringConvertible {
    @usableFromInline static let redacted = "[REDACTED]"
    
    // MARK: Properties
    
    #if DEBUG
    public let description: String
    #else
    @inlinable @inline(__always) public var description: String { Reason.redacted }
    #endif
    
    // MARK: Initializers
    
    @inlinable @inline(__always) public init(_ description: String) {
        #if DEBUG
        self.description = description
        #endif
    }
    
    @inlinable @inline(__always) public init(_ components: [Component]) {
        self.init(components.lazy.map(\.description).joined(separator: " "))
    }
    
    @inlinable @inline(__always) public init(_ components: Component...) {
        self.init(components)
    }
    
    // MARK: Components
    
    public struct Component: CustomStringConvertible, ExpressibleByStringLiteral {
        
        // MARK: Properties
        
        #if DEBUG
        public let description: String
        #else
        @inlinable @inline(__always) public var description: String { Reason.redacted }
        #endif
        
        // MARK: Initializers
        
        @inlinable @inline(__always) public init(_ description: String) {
            #if DEBUG
            self.description = description
            #endif
        }
        
        @inlinable @inline(__always) public init(stringLiteral value: StringLiteralType) {
            self.init(value)
        }
        
        // MARK: Instances
        
        @inlinable @inline(__always) public static func mark(_ value: Any) -> Self {
            self.init("« \(value) »")
        }
    }
}

// MARK: - Reason x Error

public extension Error where Self == Reason {

    // MARK: Instances

    @inlinable @inline(__always) static func reason(_ description: String) -> Self {
        .init(description)
    }

    @inlinable @inline(__always) static func reason(_ components: Self.Component...) -> Self {
        .init(components)
    }
}
