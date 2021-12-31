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
/// - Note: It can only be initialized with closures (or Autoredactable.Storage) so that its parameter expressions are not evaluated in RELEASE mode.
///
@frozen public struct Autoredactable: Error, CustomStringConvertible {
    
    // MARK: Properties
    
    @usableFromInline
    internal let storage: Storage
    
    // MARK: Initializers
    
    @inlinable @inline(__always)
    internal init(_ storage: Storage) {
        self.storage = storage
    }
    
    // MARK: Initializers (Indirect)
    
    @inlinable @inline(__always)
    public init(_ components: @autoclosure () -> [Self]) {
        self.init(Storage(components().map(\.storage.content).joined(separator: " ")))
    }
    
    // MARK: Initializers (Indirect) (Static)
    
    @inlinable @inline(__always)
    public static func text(_ value: @autoclosure () -> Any) -> Self {
        Self.init(Storage(String(describing: value())))
    }
    
    @inlinable @inline(__always)
    public static func mark(_ value: @autoclosure () -> Any) -> Self {
        Self.init([Self.text("«" as Any), Self.text(value()), Self.text("»" as Any)] as [Self])
    }
    
    // MARK: Utilities
    
    @inlinable @inline(__always)
    public var description: String { storage.content }
    
    // MARK: Storage
    
    /// An internal object that is responsible for the conditional compilation in DEBUG and RELEASE mode.
    ///
    /// - Note: It can only be initialized with closures so that its parameter expressions are not evaluated in RELEASE mode.
    ///
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
        internal init(_ content: @autoclosure () -> String) {
            #if DEBUG
            self.content = content()
            #endif
        }
    }
}
