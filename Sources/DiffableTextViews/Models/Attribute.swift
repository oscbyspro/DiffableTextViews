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
/// Plain text is empty.
///
/// - Note: The easiest way to unformat text is to filter symbosl marked as virtual.
///
public struct Attribute: OptionSet {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances - Singular
    //=------------------------------------------------------------------------=

    /// Signifies that the symbol is part of a text's formatting.
    public static let virtual = Self(rawValue: 1 << 0)
    
    /// Signifies that the symbol should be ignored by the differentiation algorithm when it is inserted.
    public static let insertable = Self(rawValue: 1 << 1)
    
    /// Signifies that the symbol should be ignored by the differentiation algorithm when it is removed.
    public static let removable = Self(rawValue: 1 << 2)
        
    /// Signifies that the symbol has no real size.
    public static let passthrough = Self(rawValue: 1 << 3)
    
    //=------------------------------------------------------------------------=
    // MARK: Instances - Composites
    //=------------------------------------------------------------------------=
    
    /// Default behavior used to describe plain text.
    public static let content = Self([])
    
    /// - Contains: .virtual, .insertable, .removable, .passthrough.
    public static let phantom = Self([.virtual, .insertable, .removable, .passthrough])
    
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
}

//=----------------------------------------------------------------------------=
// MARK: Attribute - CustomStringConvertible
//=----------------------------------------------------------------------------=

extension Attribute: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Descriptions
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        String(describing: rawValue)
    }
}
