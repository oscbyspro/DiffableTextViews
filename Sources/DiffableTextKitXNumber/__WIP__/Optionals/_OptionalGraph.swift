//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Optional x Graph
//*============================================================================*

public struct _OptionalGraph<Graph: _Graph>: _Graph where Graph.Input == Graph.Value {
    public typealias Input = Graph.Value
    public typealias Value = Graph.Value?

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) init() { }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public var min:  Input { Input.min  }
    
    @inlinable @inline(__always) public var max:  Input { Input.max  }
    
    @inlinable @inline(__always) public var zero: Input { Input.zero }
    
    @inlinable @inline(__always) public var precision: Int { Input.precision }
    
    @inlinable @inline(__always) public var optional: Bool { true }
    
    @inlinable @inline(__always) public var unsigned: Bool { Input.unsigned }
    
    @inlinable @inline(__always) public var integer:  Bool { Input.integer  }
}

//=----------------------------------------------------------------------------=
// MARK: + Nodes
//=----------------------------------------------------------------------------=

extension _OptionalGraph: _Numberable where Graph: _Numberable {
    public typealias Number = _OptionalStyle<Graph.Number>
}

extension _OptionalGraph: _Percentable where Graph: _Percentable {
    public typealias Percent = _OptionalStyle<Graph.Percent>
}

extension _OptionalGraph: _Currencyable where Graph: _Currencyable {
    public typealias Currency = _OptionalStyle<Graph.Currency>
}

//*============================================================================*
// MARK: * Optional x Graph
//*============================================================================*

extension Optional: _Value where Wrapped: _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static var _NumberTextGraph: _OptionalGraph
    <Wrapped.NumberTextGraph> { .init() }
}
