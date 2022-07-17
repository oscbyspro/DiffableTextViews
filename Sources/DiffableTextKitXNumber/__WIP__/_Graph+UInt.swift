//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Graph x Int
//*============================================================================*

public struct _Graph_UInt<Value: _Input>: _Graph, _Graph_Number, _Graph_Currency
where Value: FixedWidthInteger & UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Nodes
    //=------------------------------------------------------------------------=

    public typealias Format   =  IntegerFormatStyle<Value>
    public typealias Number   = _DefaultID_Standard<Format         >.Style
    public typealias Currency = _DefaultID_Currency<Format.Currency>.Style

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    public let max: Value
    public let precision: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(precision: Int) {
        self.precision = precision; self.max = .max
    }
    
    /// IntegerFormatStyle uses an Int, it seems; values above Int.max crash.
    @inlinable init(limit: (some _Input & BinaryInteger).Type) {
        self.precision = limit.precision; self.max = Value(limit.max)
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) public var min:  Value { .min  }
    
    @inlinable @inline(__always) public var zero: Value { .zero }
    
    @inlinable @inline(__always) public var optional: Bool { false }
    
    @inlinable @inline(__always) public var unsigned: Bool { true  }
    
    @inlinable @inline(__always) public var integer:  Bool { true  }
}

//=----------------------------------------------------------------------------=
// MARK: + UInt
//=----------------------------------------------------------------------------=

extension UInt: _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public typealias   NumberTextGraph = _Graph_UInt<Self>
    public static let _numberTextGraph = _Graph_UInt<Self>(limit: Int.self)
}

//=----------------------------------------------------------------------------=
// MARK: + UInt8
//=----------------------------------------------------------------------------=

extension UInt8: _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public typealias   NumberTextGraph = _Graph_UInt<Self>
    public static let _numberTextGraph = _Graph_UInt<Self>(precision: 3)
}

//=----------------------------------------------------------------------------=
// MARK: + UInt16
//=----------------------------------------------------------------------------=

extension UInt16: _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public typealias   NumberTextGraph = _Graph_UInt<Self>
    public static let _numberTextGraph = _Graph_UInt<Self>(precision: 5)
}

//=----------------------------------------------------------------------------=
// MARK: + UInt32
//=----------------------------------------------------------------------------=

extension UInt32: _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public typealias   NumberTextGraph = _Graph_UInt<Self>
    public static let _numberTextGraph = _Graph_UInt<Self>(precision: 10)
}

//=----------------------------------------------------------------------------=
// MARK: + UInt64
//=----------------------------------------------------------------------------=

extension UInt64: _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public typealias   NumberTextGraph = _Graph_UInt<Self>
    public static let _numberTextGraph = _Graph_UInt<Self>(limit: Int64.self)
}
