//
//  Attribute.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

//*============================================================================*
// MARK: * Attribute
//*============================================================================*

/// A set of options, where each option represents a specialized behavior.
///
/// Plain text is empty. Spacers are both prefixing and suffixing.
///
/// - Singular: formatting, insertable, removable, prefixing, suffixing.
/// - Composites: content, prefix, suffix, spacer.
///
/// - Note: The easiest way to unformat text is to filter out symbols marked as formatting.
///
public struct Attribute: OptionSet, CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances - Singular
    //=------------------------------------------------------------------------=
    
    /// Signifies that the symbol is part of a text's formatting and therefore not real.
    public static let formatting = Self(rawValue: 1 << 0)
    
    /// Signifies that the symbol should be ignored by the differentiation algorithm when it is inserted.
    public static let insertable = Self(rawValue: 1 << 1)
    
    /// Signifies that the symbol should be ignored by the differentiation algorithm when it is removed.
    public static let removable  = Self(rawValue: 1 << 2)
    
    /// Signifies that the symbol should direct the user's text selection forwards.
    public static let prefixing  = Self(rawValue: 1 << 3)
    
    /// Signifies that the symbol should direct the user's text selection backwards.
    public static let suffixing  = Self(rawValue: 1 << 4)
    
    //
    // MARK: Instances - Composites
    //=------------------------------------------------------------------------=
    
    /// Default behavior used to describe plain text. Contains no options.
    public static let content = Self([])
    
    /// Contains: .formatting, .insertable, .removable, .prefixing.
    public static let prefix  = Self([.formatting, .insertable, .removable, .prefixing])
    
    /// Contains: .formatting, .insertable, .removable, .suffixing.
    public static let suffix  = Self([.formatting, .insertable, .removable, .suffixing])
    
    /// Contains: .formatting, .insertable, .removable, .prefixing, .suffixing.
    public static let spacer  = Self([.formatting, .insertable, .removable, .prefixing, .suffixing])
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    public let rawValue: UInt8
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        String(describing: rawValue)
    }
}
