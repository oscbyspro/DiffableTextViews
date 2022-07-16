//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//*============================================================================*
// MARK: * Optional
//*============================================================================*

public struct _Optional<Graph: _Graph>: DiffableTextStyleWrapper, _Protocol_Internal {
    public typealias Style = Graph.Style
    public typealias Cache = Graph.Cache
    
    public typealias Input = Graph.Input
    public typealias Value = Graph.Input?

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var style: Style

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ style: Style) { self.style = style }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable var bounds: NumberTextBounds<Input>? {
        get { style.bounds }
        set { style.bounds = newValue }
    }

    @inlinable var precision: NumberTextPrecision<Input>? {
        get { style.precision }
        set { style.precision = newValue }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(_ value: Value, with cache: inout Cache) -> String {
        value.map({ style.format($0, with: &cache) }) ?? String()
    }

    @inlinable public func interpret(_ value: Value, with cache: inout Cache) -> Commit<Value> {
        value.map({ Commit(style.interpret($0, with: &cache)) }) ?? Commit()
    }

    @inlinable public func resolve(_ proposal: Proposal, with cache: inout Cache) throws -> Commit<Value> {
        try cache.resolve(proposal)
    }
}
