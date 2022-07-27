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
// MARK: * Optional x Graph
//*============================================================================*

public struct _OptionalGraph<Graph: _Graph>: _Graph where Graph.Input == Graph.Value {
    public typealias Value = Graph.Value?
    public typealias Input = Graph.Input
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let graph: Graph
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) init(_ graph: Graph) { self.graph = graph }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public var min:  Input { graph.min  }
    
    @inlinable @inline(__always) public var max:  Input { graph.max  }
    
    @inlinable @inline(__always) public var zero: Input { graph.zero }
    
    @inlinable @inline(__always) public var precision: Int { graph.precision }
    
    @inlinable @inline(__always) public var optional: Bool { true }
    
    @inlinable @inline(__always) public var unsigned: Bool { graph.unsigned }
    
    @inlinable @inline(__always) public var integer:  Bool { graph.integer  }
}

//=----------------------------------------------------------------------------=
// MARK: + Nodes
//=----------------------------------------------------------------------------=

extension _OptionalGraph: _Numberable
where Graph: _Numberable, Graph.Number: NullableTextStyle {
    public typealias Number = _OptionalStyle<Graph.Number>
}

extension _OptionalGraph: _Percentable
where Graph: _Percentable, Graph.Percent: NullableTextStyle {
    public typealias Percent = _OptionalStyle<Graph.Percent>
}

extension _OptionalGraph: _Currencyable
where Graph: _Currencyable, Graph.Currency: NullableTextStyle {
    public typealias Currency = _OptionalStyle<Graph.Currency>
}

//=----------------------------------------------------------------------------=
// MARK: + Optional(s)
//=----------------------------------------------------------------------------=

extension Optional: _Value where Wrapped: _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public static var _NumberTextGraph: _OptionalGraph
    <Wrapped.NumberTextGraph> { .init(Wrapped._NumberTextGraph) }
}
