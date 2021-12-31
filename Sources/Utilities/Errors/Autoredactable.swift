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
/// - MemoryLayout«Self».stride == 1 in RELEASE mode (vs 16 in DEBUG mode).
///
/// - Note: Parameters and related calculations *should* be ignored in RELEASE mode.
///
@frozen public struct Autoredactable: Error, CustomStringConvertible, ExpressibleByArrayLiteral, ExpressibleByStringLiteral {

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
    public init(_ components: Self...) {
        self.init(Self._reduce(components))
    }
    
    @inlinable @inline(__always)
    public init(stringLiteral value: String) {
        self.init(Self._text(value))
    }
    
    @inlinable @inline(__always)
    public init(arrayLiteral elements: Any...) {
        self.init(Self._mark((Self._reduce(elements))))
    }
            
    @inlinable @inline(__always)
    public static func text(_ value: Any) -> Self {
        Self.init(Self._text(value))
    }
    
    @inlinable @inline(__always)
    public static func mark(_ value: Any) -> Self {
        Self.init(Self._mark(value))
    }
    
    // MARK: Utilities
    
    @inlinable @inline(__always)
    public var description: String { storage.content }

    // MARK: Helpers
    
    @inlinable @inline(__always)
    internal static func _text(_ value: Any) -> String {
        .init(describing: value)
    }
    
    @inlinable @inline(__always)
    internal static func _mark(_ value: Any) -> String {
        _reduce(["«", value, "»"])
    }
    
    @inlinable @inline(__always)
    internal static func _reduce(_ values: [Any]) -> String {
        values.lazy.map(_text).joined(separator: " ")
    }
    
    // MARK: Storage
    
    /// A super simple object that encapsulates the compiler conditions.
    @frozen @usableFromInline internal struct Storage {
        @usableFromInline static let redacted = "[REDACTED]"
        
        // MARK: Properties
        
        #if DEBUG
        @usableFromInline
        internal let content: String
        #else
        @inlinable @inline(__always)
        internal var content: String { Self.redacted }
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
