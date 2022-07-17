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

//*============================================================================*
// MARK: * Style
//*============================================================================*

public struct _Style<Graph: _Graph>: _Protocol_Internal {
    public typealias Cache = Graph.Cache
    public typealias Input = Graph.Input
    public typealias Value = Graph.Input
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var id: Graph
    @usableFromInline var bounds: _Bounds<Input>?
    @usableFromInline var precision: _Precision<Input>?
    
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
        public typealias Style = Graph.Style
        public typealias Cache = Graph.Cache
        public typealias Input = Graph.Input
        public typealias Value = Graph.Input?

        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=

        public var style: Style

        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=

        @inlinable init(_ style: Style) { self.style = style }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=

        @inlinable var bounds: _Bounds<Input>? {
            get { style.bounds }
            set { style.bounds = newValue }
        }

        @inlinable var precision: _Precision<Input>? {
            get { style.precision }
            set { style.precision = newValue }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=

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
}
