//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Symbol
//*============================================================================*

/// A character and an attribute describing its behavior.
public struct Symbol: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=

    /// A phantom space symbol: U+0020.
    public static let spacer = Self(character: "\u{0020}", attribute: .phantom)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var character: Character
    public var attribute: Attribute
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable public init(character: Character, attribute: Attribute) {
        self.character = character; self.attribute = attribute
    }
    
    @inlinable public init(_ character: Character, as attribute: Attribute) {
        self.character = character; self.attribute = attribute
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public static func content(_ character: Character) -> Self {
        Self(character, as: .content)
    }
    
    @inlinable @inline(__always) public static func phantom(_ character: Character) -> Self {
        Self(character, as: .phantom)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) public var virtual: Bool {
        self.attribute.contains(.virtual)
    }

    @inlinable @inline(__always) public var nonvirtual: Bool {
        self.attribute.contains(.virtual) == false
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Inspection
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) public func contains(_ character: Character) -> Bool {
        self.character == character
    }

    @inlinable @inline(__always) public func contains(_ attribute: Attribute) -> Bool {
        self.attribute.contains(attribute)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension Symbol: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        "(\(character), \(attribute))"
    }
}