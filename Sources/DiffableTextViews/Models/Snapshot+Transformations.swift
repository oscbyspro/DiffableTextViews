//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

public extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Anchor
    //=------------------------------------------------------------------------=
    
    /// Sets the anchor to the endIndex.
    @inlinable mutating func anchor() {
        self._anchorIndex = endIndex
    }
    
    /// Sets the anchor to the position.
    @inlinable mutating func anchor(_ position: Index?) {
        self._anchorIndex = position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(attributes position: Index,
    with transform: (inout Attribute) -> Void) {
        transform(&_attributes[position.attribute])
    }
    
    @inlinable mutating func update<S: Sequence>(attributes sequence: S,
    with transform: (inout Attribute) -> Void) where S.Element == Index {
        for position in sequence {
            transform(&_attributes[position.attribute])
        }
    }
    
    @inlinable mutating func update<R: RangeExpression>(attributes range: R,
    with transform: (inout Attribute) -> Void) where R.Bound == Index {
        for position in indices[range.relative(to: self)] {
            transform(&_attributes[position.attribute])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Replacements
    //=------------------------------------------------------------------------=

    @inlinable mutating func replaceSubrange<C>(_ range: Range<Index>,
        with elements: C) where C: Collection, C.Element == Symbol {
        _characters.replaceSubrange(
        range.lowerBound.character ..<
        range.upperBound.character,
        with: elements.lazy.map(\.character))
        _attributes.replaceSubrange(
        range.lowerBound.attribute ..<
        range.upperBound.attribute,
        with: elements.lazy.map(\.attribute))
    }
    
    @inlinable mutating func append(_ element: Symbol) {
        _characters.append(element.character)
        _attributes.append(element.attribute)
    }
    
    @inlinable mutating func append<S: Sequence>(contentsOf elements: S) where S.Element == Symbol {
        _characters.append(contentsOf: elements.lazy.map(\.character))
        _attributes.append(contentsOf: elements.lazy.map(\.attribute))
    }
    
    @inlinable mutating func insert(_ element: Element, at position: Index) {
        _characters.insert(element.character, at: position.character)
        _attributes.insert(element.attribute, at: position.attribute)
    }
    
    @inlinable mutating func insert<S: Collection>(contentsOf elements: S, at i: Index) where S.Element == Symbol {
        _characters.insert(contentsOf: elements.lazy.map(\.character), at: i.character)
        _attributes.insert(contentsOf: elements.lazy.map(\.attribute), at: i.attribute)
    }
    
    @inlinable @discardableResult mutating func remove(at position: Index) -> Symbol {
        Symbol(_characters.remove(at: position.character), as: _attributes.remove(at: position.attribute))
    }
}
