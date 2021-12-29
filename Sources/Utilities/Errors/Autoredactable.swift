//
//  Autoredactable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-27.
//

// MARK: - Autoredactable

/// An error that contains a description in DEBUG mode, but is redacted in RELEASE mode.
///
/// - MemoryLayout«Self».size == 0 in RELEASE mode.
///
public struct Autoredactable: Error, CustomStringConvertible {
    @usableFromInline internal static let redacted = "[REDACTED]"
    
    // MARK: Properties
    
    #if DEBUG
    @usableFromInline internal let content: String
    #else
    @inlinable @inline(__always) internal var content: String { Autoredactable.redacted }
    #endif
    
    // MARK: Initializers
    
    @inlinable @inline(__always) internal init(content: @autoclosure () -> String) {
        #if DEBUG
        self.content = content()
        #endif
    }
        
    @inlinable @inline(__always) public init(_ components: Component...) {
        self.init(content: Autoredactable.combine(components))
    }
    
    // MARK: Descriptions
    
    @inlinable @inline(__always) public var description: String { content }
    
    // MARK: Helpers
    
    @inlinable @inline(__always) internal static func text(_ value: Any) -> String {
        String(describing: value)
    }
    
    @inlinable @inline(__always) internal static func mark(_ value: Any) -> String {
        combine(["«", value, "»"])
    }
    
    @inlinable @inline(__always) internal static func combine(_ values: [Any]) -> String {
        values.lazy.map(text).joined(separator: " ")
    }
    
    // MARK: Components
    
    public struct Component: CustomStringConvertible, ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
        
        // MARK: Properties
        
        #if DEBUG
        @usableFromInline internal let content: String
        #else
        @inlinable @inline(__always) internal var content: String { Autoredactable.redacted }
        #endif
        
        // MARK: Initializers
        
        @inlinable @inline(__always) internal init(content: @autoclosure () -> String) {
            #if DEBUG
            self.content = content()
            #endif
        }
        
        // MARK: Initializers: Literals
        
        @inlinable @inline(__always) public init(stringLiteral value: String) {
            self.init(content: value)
        }
        
        @inlinable @inline(__always) public init(arrayLiteral elements: Any...) {
            self.init(content: Autoredactable.mark((Autoredactable.combine(elements))))
        }
        
        // MARK: Initializers: Static
        
        @inlinable @inline(__always) public static func text(_ value: Any) -> Self {
            Self.init(content: Autoredactable.text(value))
        }
        
        @inlinable @inline(__always) public static func mark(_ value: Any) -> Self {
            Self.init(content: Autoredactable.mark(value))
        }
        
        // MARK: Descriptions
        
        @inlinable @inline(__always) public var description: String { content }
    }
}
