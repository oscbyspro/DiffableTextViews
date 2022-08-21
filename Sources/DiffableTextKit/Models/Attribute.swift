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

/// A set of behavioral options, such that plain text has none.
///
/// The easiest way to unformat text is to filter characters marked as virtual.
///
public struct Attribute: CustomStringConvertible, OptionSet {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    /// Marks a character that is not real and should not be parsed.
    public static let virtual = Self(rawValue: 1 << 0)
    
    /// Marks a character that should be ignored when inserted.
    public static let insertable = Self(rawValue: 1 << 1)
    
    /// Marks a character that should be ignored when removed.
    public static let removable = Self(rawValue: 1 << 2)

    /// Marks a character that has no real size and should be passed through.
    public static let passthrough = Self(rawValue: 1 << 3)
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    /// An attribute describing normal characters.
    ///
    /// It contains no attributes other than itself; it is empty.
    ///
    public static let content = Self([])
    
    /// An attribute describing formatting characters.
    ///
    /// It contains: virtual, insertable, removable, passthrough.
    ///
    public static let phantom = Self([virtual, insertable, removable, passthrough])

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
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    public var description: String {
        String(describing: rawValue)
    }
}
