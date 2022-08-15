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
public struct Symbol: CustomStringConvertible, Equatable,
ExpressibleByExtendedGraphemeClusterLiteral {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var character: Character
    public var attribute: Attribute
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public init(
    _ character: Character, as attribute: Attribute = .content) {
        self.character = character;  self.attribute = attribute
    }
    
    @inlinable public init(extendedGraphemeClusterLiteral character: Character) {
        self.init(character)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public var virtual: Bool {
        self.attribute.contains(.virtual)
    }
    
    @inlinable @inline(__always) public var nonvirtual: Bool {
        self.attribute.contains(.virtual) == false
    }
    
    @inlinable @inline(__always) public func contains(_ character: Character) -> Bool {
        self.character == character
    }
    
    @inlinable @inline(__always) public func contains(_ attribute: Attribute) -> Bool {
        self.attribute.contains(attribute)
    }
    
    public var description: String {
        "(\(character), \(attribute))"
    }
}

//*============================================================================*
// MARK: * Symbol x Sequence [...]
//*============================================================================*

extension Sequence where Element == Symbol {
    
    /// A sequence of nonvirtual characters.
    @inlinable public func nonvirtuals() -> String {
        String(lazy.nonvirtuals())
    }
}

//*============================================================================*
// MARK: * Symbol x Sequence x Lazy [...]
//*============================================================================*

extension LazySequenceProtocol where Element == Symbol {
    
    /// A lazy sequence of nonvirtual characters.
    @inlinable public func nonvirtuals() -> LazyMapSequence<LazyFilterSequence<Elements>, Character> {
        filter({!$0.attribute.contains(.virtual)}).map({$0.character})
    }
}
