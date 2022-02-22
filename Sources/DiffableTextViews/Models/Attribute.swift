//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Attribute
//*============================================================================*

/// A set of options, where each option represents a specialized behavior.
///
/// Plain text has no attributes.
///
/// - Singular: virtual, insertable, removable, passthrough.
/// - Composites: content, phantom.
///
/// - Note: The easiest way to unformat text is to exclude symbols marked as virtual.
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

    /// Signifies that the symbol have no effective size and be passed through.
    public static let passthrough = Self(rawValue: 1 << 3)
    
    //=------------------------------------------------------------------------=
    // MARK: Instances - Composites
    //=------------------------------------------------------------------------=
    
    /// A standard attribute describing standard characters.
    ///
    /// - It contains no attributes.
    ///
    public static let content = Self([])
    
    /// A formatting attribute describing formatting characters.
    ///
    /// - It contains: virtual, insertable, removable, lookaheadable, lookbehindable.
    ///
    public static let phantom = Self([.virtual, .insertable, .removable, .passthrough])
    
    //=------------------------------------------------------------------------=
    // MARK: State
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
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension Attribute: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        String(describing: rawValue)
    }
}
