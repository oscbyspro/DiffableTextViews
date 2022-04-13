//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Index
//*============================================================================*

/// A snapshot location that knows its encoded offset.
@usableFromInline struct Index<Scheme: _Scheme>: _Index {
    @usableFromInline typealias Position = Scheme.Position
    @usableFromInline typealias Subindex = Snapshot.Index

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @usableFromInline let position: Position
    @usableFromInline let subindex: Subindex

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(_ subindex: Subindex, at position: Position) {
        self.subindex = subindex
        self.position = position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable var character: String.Index {
        subindex.character
    }
    
    @inlinable var attribute: Int {
        subindex.attribute
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=

    @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.position == rhs.position
    }
    
    @inlinable static func <  (lhs: Self, rhs: Self) -> Bool {
        lhs.position <  rhs.position
    }
}

//*============================================================================*
// MARK: * Index x Protocol
//*============================================================================*

/// This exists because generic extensions are not yet possible.
@usableFromInline protocol _Index: Comparable {
    associatedtype Scheme: _Scheme
    
    //=------------------------------------------------------------------------=
    // MARK: Aliases
    //=------------------------------------------------------------------------=
    
    typealias Position = Scheme.Position
    typealias Subindex = Snapshot.Index

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var position: Position { get }
    @inlinable var subindex: Subindex { get }
}
