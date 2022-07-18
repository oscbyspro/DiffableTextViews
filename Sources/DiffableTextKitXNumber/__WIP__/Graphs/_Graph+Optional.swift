//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Graph x Optional
//*============================================================================*

public struct _Graph_Optional<Graph: _Graph>: _Graph where Graph.Input == Graph.Value {
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

extension _Graph_Optional {
    public typealias Number = _Optional<Graph.Number>
}

extension _Graph_Optional: _Graph_Percentable where Graph: _Graph_Percentable {
    public typealias Percent = _Optional<Graph.Percent>
}

extension _Graph_Optional: _Graph_Currencyable where Graph: _Graph_Currencyable {
    public typealias Currency = _Optional<Graph.Currency>
}

//*============================================================================*
// MARK: * Graph x Optional
//*============================================================================*

extension Optional: _Value where Wrapped: _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static var _numberTextGraph: _Graph_Optional
    <Wrapped.NumberTextGraph> { .init() }
}
