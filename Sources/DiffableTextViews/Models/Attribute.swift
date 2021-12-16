//
//  Attribute.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

import protocol Utilities.Transformable

// MARK: - Attribute

/// A set of options, where each option represents a specialized behavior.
///
/// The easiest way to unformat text is to exclude symbols with the format attribute.
///
/// - Ordinary text has a raw value of 0, and is empty.
/// - A spacer is defined as both a prefix and a suffix.
///
public struct Attribute: OptionSet, Transformable {
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
    
    // MARK: Composites: Intuitive
    
    #warning("Remove/rethink.")
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
