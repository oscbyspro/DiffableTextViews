//
//  Autoredactable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-27.
//

// MARK: - Autoredactable

/// An error that contains a description in DEBUG mode, but is redacted otherwise.
///
/// It is essentially Void in RELEASE mode, and a String builder in DEBUG mode.
///
/// - MemoryLayout«Self».size == 0 in RELEASE mode (vs 16 in DEBUG mode).
/// - MemoryLayout«Self».alignment == 1 in RELEASE mode (vs 8 in DEBUG mode).
/// - MemoryLayout«Self».stride == 1 in RELEASE mode  (vs 16 in DEBUG mode).
///
/// - Note: Parameters and related calculations *should* be ignored in RELEASE mode.
///
@frozen public struct Autoredactable: Error, CustomStringConvertible {
    
    // MARK: Properties
    
    @usableFromInline
    internal let storage: Storage
    
    // MARK: Initializers

    @inlinable @inline(__always)
    internal init(_ content: @autoclosure () -> String) {
        self.storage = .init(content: content)
    }
    
    // MARK: Initializers (Indirect)
        
    @inlinable @inline(__always)
    public init(_ components: Component...) {
        self.init(Autoredactable.combine(components))
    }
    
    // MARK: Utilities
    
    @inlinable @inline(__always)
    public var description: String { storage.content }
    
    // MARK: Helpers
    
    @inlinable @inline(__always)
    internal static func text(_ value: Any) -> String {
        .init(describing: value)
    }
    
    @inlinable @inline(__always)
    internal static func mark(_ value: Any) -> String {
        combine(["«", value, "»"])
    }
    
    @inlinable @inline(__always)
    internal static func combine(_ values: [Any]) -> String {
        values.lazy.map(text).joined(separator: " ")
    }
    
    // MARK: Component
    
    @frozen public struct Component: ExpressibleByStringLiteral, ExpressibleByArrayLiteral {
        
        // MARK: Properties
        
        @usableFromInline
        internal let storage: Storage
        
        // MARK: Initializers

        @inlinable @inline(__always)
        internal init(_ content: @autoclosure () -> String) {
            self.storage = .init(content: content)
        }
        
        // MARK: Initializers (Indirect)

        @inlinable @inline(__always)
        public init(stringLiteral value: String) {
            self.init(value)
        }
        
        @inlinable @inline(__always)
        public init(arrayLiteral elements: Any...) {
            self.init(Autoredactable.mark((Autoredactable.combine(elements))))
        }
                
        @inlinable @inline(__always)
        public static func text(_ value: Any) -> Self {
            Self.init(Autoredactable.text(value))
        }
        
        @inlinable @inline(__always)
        public static func mark(_ value: Any) -> Self {
            Self.init(Autoredactable.mark(value))
        }
    }
    
    // MARK: Storage
    
    @frozen @usableFromInline internal struct Storage {
        @usableFromInline internal static let content = "[REDACTED]"
        
        // MARK: Properties
        
        #if DEBUG
        @usableFromInline
        internal let content: String
        #else
        @inlinable @inline(__always)
        internal var content: String { Self.content }
        #endif

        // MARK: Initializers

        @inlinable @inline(__always)
        internal init(content: () -> String) {
            #if DEBUG
            self.content = content()
            #endif
        }
    }
}
