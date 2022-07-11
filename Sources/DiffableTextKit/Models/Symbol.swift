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
public struct Symbol: Equatable, ExpressibleByExtendedGraphemeClusterLiteral {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var character: Character
    public var attribute: Attribute
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ character: Character, as attribute: Attribute = .content) {
        self.character = character
        self.attribute = attribute
    }
    
    @inlinable public init(extendedGraphemeClusterLiteral character: Character) {
        self.init(character)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public var virtual: Bool {
        self.attribute.contains(.virtual)
    }
    
    @inlinable @inline(__always)
    public var nonvirtual: Bool {
        self.attribute.contains(.virtual) == false
    }
    
    @inlinable @inline(__always)
    public func contains(_ character: Character) -> Bool {
        self.character == character
    }
    
    @inlinable @inline(__always)
    public func contains(_ attribute: Attribute) -> Bool {
        self.attribute.contains(attribute)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Descriptions
//=----------------------------------------------------------------------------=

extension Symbol: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    public var description: String {
        "(\(character), \(attribute))"
    }
}
