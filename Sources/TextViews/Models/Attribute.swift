//
//  Attribute.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

import SwiftUI

// MARK: - Attribute

/// A set of options, where each option represents a specialized behavior.
///
/// The easiest way to unformat text is to exclude symbols with the format attribute.
///
/// - Ordinary text has a raw value of 0, and is empty.
/// - A spacer is defined as both a prefix and a suffix.
///
public struct Attribute: OptionSet {
    /// Signifies that the symbol is part of formatting and therefore not 'real'.
    public static let format: Self = .init(rawValue: 1 << 0)
    /// Signifies that the symbol should direct the cursor in the forwards direction.
    public static let prefix: Self = .init(rawValue: 1 << 1)
    /// Signifies that the symbol should direct the cursor in the backwards direction.
    public static let suffix: Self = .init(rawValue: 1 << 2)
    /// Signifies that the symbol will be ignored by the differentiation algorithm when it is inserted.
    public static let insert: Self = .init(rawValue: 1 << 3)
    /// Signifies that the symbol will be ignored by the differentiation algorithm when it is removed.
    public static let remove: Self = .init(rawValue: 1 << 4)
    /// A free bit, 0b00100000.
    public static let xAlpha: Self = .init(rawValue: 1 << 5)
    /// A free bit, 0b01000000.
    public static let xBeta:  Self = .init(rawValue: 1 << 6)
    /// A free bit, 0b10000000.
    public static let xGamma: Self = .init(rawValue: 1 << 7)
    
    // MARK: Properties
    
    public let rawValue: UInt8
    
    // MARK: Initializers
    
    @inlinable public init(rawValue: UInt8 = .zero) {
        self.rawValue = rawValue
    }
    
    @inlinable public init(_ attributes: Self...) {
        self.init(attributes)
    }
    
    // MARK: Utilities

    @inlinable public func update(_ transform: (inout Self) -> Void) -> Self {
        var result = self; transform(&result); return result
    }
    
    // MARK: Components: Domain

    public struct Collection {
        public static let all:    Self = .init(Attribute(rawValue: .max))
        public static let normal: Self = .init(.format, .prefix, .suffix, .insert, .remove)
        public static let extras: Self = .init(.xAlpha, .xBeta, .xGamma)

        // MARK: Properties
        
        public let attribute: Attribute
        
        // MARK: Initializersb
        
        @inlinable init(_ attribute: Attribute...) {
            self.attribute = .init(attribute)
        }
    }
    
    @inlinable @inline(__always) public static func collection(_ collection: Collection) -> Self {
        collection.attribute
    }
    
    // MARK: Components: Set
    
    public struct Composite {
        public static let spacer: Self = .init(.prefix, .suffix)
        public static let change: Self = .init(.insert, .remove)
        
        // MARK: Properties
        
        public let attribute: Attribute
        
        // MARK: Initializers
        
        @inlinable init(_ attribute: Attribute...) {
            self.attribute = .init(attribute)
        }
    }
    
    @inlinable @inline(__always) public static func composite(_ composite: Composite) -> Self {
        composite.attribute
    }
    
    // MARK: Components: Intuative
    
    public struct Intuitive {
        public static let content: Self = .init()
        public static let prefix:  Self = .init(.format, .insert, .remove, .prefix)
        public static let suffix:  Self = .init(.format, .insert, .remove, .suffix)
        public static let spacer:  Self = .init(.format, .insert, .remove, .prefix, .suffix)
        
        // MARK: Properties
        
        public let attribute: Attribute
        
        // MARK: Initializers
        
        @inlinable init(_ attribute: Attribute...) {
            self.attribute = .init(attribute)
        }
    }
    
    @inlinable @inline(__always) public static func intuitive(_ intuitive: Intuitive) -> Self {
        intuitive.attribute
    }
}
