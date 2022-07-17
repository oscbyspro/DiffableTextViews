//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

public struct _Graph_Optional<Input: _Input>: _Graph {
    public typealias Value = Input?

    //=------------------------------------------------------------------------=
    // MARK: Types
    //=------------------------------------------------------------------------=

//    public typealias Number   = _DefaultID_Standard<Base         >.Style
//    public typealias Currency = _DefaultID_Currency<Base.Currency>.Style
    
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
// MARK: + Optional
//=----------------------------------------------------------------------------=

extension Optional: _Value where Wrapped: _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public
    static var _numberTextGraph:
    _Graph_Optional<Wrapped> { .init() }
}
