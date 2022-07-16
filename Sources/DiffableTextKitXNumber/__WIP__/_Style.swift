//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

#warning("WIP.................................................................")
//*============================================================================*
// MARK: * Style
//*============================================================================*

public struct _Style<Graph: _Graph>: _Protocol_Internal {
    public typealias Cache = Graph.Cache
    public typealias Input = Graph.Input
    public typealias Value = Graph.Input
    
    @usableFromInline typealias Bounds = _Bounds<Input>
    @usableFromInline typealias Precision = _Precision<Input>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var id: Graph
    @usableFromInline var bounds: Bounds?
    @usableFromInline var precision: Precision?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ id: Graph) { self.id = id }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        var result = self; result.id.locale = locale; return self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func cache() -> Cache {
        Graph.cache(self)
    }
    
    @inlinable public func update(_ cache: inout Cache) {
        if cache.style.id == id { cache.style = self } else { cache = self.cache() }
    }
    
    //*========================================================================*
    // MARK: * Optional
    //*========================================================================*
    
    public struct Optional: DiffableTextStyleWrapper, _Protocol_Internal {
        public typealias Graph = _Style.Graph
        public typealias Cache = _Style.Cache
        public typealias Value = _Style.Value?

        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=

        public var style: _Style

        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=

        @inlinable init(_ style: _Style) { self.style = style }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=

        @inlinable var bounds: Bounds? {
            get { style.bounds }
            set { style.bounds = newValue }
        }

        @inlinable var precision: Precision? {
            get { style.precision }
            set { style.precision = newValue }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=

        @inlinable public func format(_ value: Value,
        with cache: inout Cache) -> String {
            value.map({ style.format($0, with: &cache) }) ?? String()
        }

        @inlinable public func interpret(_ value: Value,
        with cache: inout Cache) -> Commit<Value> {
            value.map({ Commit(style.interpret($0, with: &cache)) }) ?? Commit()
        }

        @inlinable public func resolve(_ proposal: Proposal,
        with cache: inout Cache) throws -> Commit<Value> {
            try cache.resolve(proposal)
        }
    }
}
