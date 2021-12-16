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
/// Ordinary text is empty. Spacers are both prefixing and suffixing.
///
/// - Singular: formatting, prefixing, suffixing, insertable, removable.
/// - Composites: content, prefix, suffix, spacer.
///
/// - Note: The easiest way to unformat text is to filter out symbols marked as formatting.
///
public struct Attribute: OptionSet, Transformable {
    
    // MARK: Singular
    
    /// Signifies that the symbol is part of formatting and therefore not 'real'.
    public static let formatting = Self(rawValue: 1 << 0)
    /// Signifies that the symbol should direct the cursor in the forwards direction.
    public static let prefixing = Self(rawValue: 1 << 1)
    /// Signifies that the symbol should direct the cursor in the backwards direction.
    public static let suffixing = Self(rawValue: 1 << 2)
    /// Signifies that the symbol will be ignored by the differentiation algorithm when it is inserted.
    public static let insertable = Self(rawValue: 1 << 3)
    /// Signifies that the symbol will be ignored by the differentiation algorithm when it is removed.
    public static let removable = Self(rawValue: 1 << 4)
    
    // MARK: Composites
    
    /// Empty option set.
    public static let content = Self()
    /// Contains: .formatting, .insertable, .removable, .prefixing.
    public static let prefix = Self(.formatting, .insertable, .removable, .prefixing)
    /// Contains: .formatting, .insertable, .removable, .suffixing.
    public static let suffix = Self(.formatting, .insertable, .removable, .suffixing)
    /// Contains: .formatting, .insertable, .removable, .prefixing, .suffixing.
    public static let spacer = Self(.formatting, .insertable, .removable, .prefixing, .suffixing)
    
    // MARK: Properties
    
    public let rawValue: UInt8
    
    // MARK: Initializers
    
    @inlinable public init(rawValue: UInt8 = 0) {
        self.rawValue = rawValue
    }
    
    @inlinable public init(_ attributes: Self...) {
        self.init(attributes)
    }
}
