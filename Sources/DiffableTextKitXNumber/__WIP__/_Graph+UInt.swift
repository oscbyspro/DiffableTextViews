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

public struct _Graph_UInt<Value: _Input>: _Graph
where Value: FixedWidthInteger & UnsignedInteger {
    public typealias Base = IntegerFormatStyle<Value>

    //=------------------------------------------------------------------------=
    // MARK: Types
    //=------------------------------------------------------------------------=

//    public typealias Number   = _DefaultID_Standard<Base         >.Style
//    public typealias Currency = _DefaultID_Currency<Base.Currency>.Style

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    public let min: Value
    public let max: Value
    public let precision: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(precision: Int, min: Value = .min, max: Value = .min) {
        self.min = min; self.max = max; self.precision = precision
    }
    
    /// IntegerFormatStyle uses an Int, I think, because values above Int.max crash.
    @inlinable init<T>(limit: T.Type) where T: _Input & SignedInteger & BinaryInteger {
        self.init(precision: limit.precision, max: Value(limit.max))
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

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
