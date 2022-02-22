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
/// - Singular: virtual, insertable, removable, lookaheadable, lookbehindable.
/// - Couples: dynamic, passthrough.
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

    /// Signifies that the symbol can be passed through in the forwards direction.
    public static let lookaheadable = Self(rawValue: 1 << 3)
    
    /// Signifies that the symbol can be passed through in the backwards direction.
    public static let lookbehindable = Self(rawValue: 1 << 4)

    //=------------------------------------------------------------------------=
    // MARK: Instances - Couples
    //=------------------------------------------------------------------------=
    
    /// A combination of insertable and removable.
    public static let dynamic = Self([.insertable, .removable])
    
    /// A combination of lookaheadable and lookbehindable.
    public static let passthrough = Self([.lookaheadable, .lookbehindable])
    
    //=------------------------------------------------------------------------=
    // MARK: Instances - Composites
    //=------------------------------------------------------------------------=
    
    /// The default attribute. It represents standard text.
    ///
    /// - Contains no attributes.
    ///
    public static let content = Self([])
    
    /// A formatting attribute. It represents redundant and/or noninteractable text.
    ///
    /// - Contains: virtual, insertable, removable, lookaheadable, lookbehindable.
    ///
    public static let phantom = Self([.virtual, .insertable, .removable, .lookaheadable, .lookbehindable])
    
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
// MARK: + CustomStringConvertible
//=----------------------------------------------------------------------------=

extension Attribute: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Descriptions
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        String(describing: rawValue)
    }
}
