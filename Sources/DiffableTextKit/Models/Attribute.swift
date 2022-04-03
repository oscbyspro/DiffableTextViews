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

/// A set of behavioral options.
///
/// Plain text has no attributes.
///
/// - Note: The easiest way to unformat text is to exclude symbols marked as virtual.
///
public struct Attribute: OptionSet {

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
// MARK: + Singular
//=----------------------------------------------------------------------------=

public extension Attribute {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=

    /// Signifies that the symbol is not real and should not be parsed.
    static let virtual = Self(rawValue: 1 << 0)
    
    /// Signifies that the symbol should be ignored when it is inserted.
    static let insertable = Self(rawValue: 1 << 1)
    
    /// Signifies that the symbol should be ignored when it is removed.
    static let removable = Self(rawValue: 1 << 2)

    /// Signifies that the symbol has no interactive size and should be passed through.
    static let passthrough = Self(rawValue: 1 << 3)
}

//=----------------------------------------------------------------------------=
// MARK: + Composites
//=----------------------------------------------------------------------------=

public extension Attribute {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    /// A standard attribute describing standard characters.
    ///
    /// It contains no attributes.
    ///
    static let content = Self([])
    
    /// A formatting attribute describing formatting characters.
    ///
    /// It contains: virtual, insertable, removable, passthrough.
    ///
    static let phantom = Self([.virtual, .insertable, .removable, .passthrough])
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
