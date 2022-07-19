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
// MARK: * Graph x UInt
//*============================================================================*

public struct _UInt<Value>: _Graph, _Numberable, _Currencyable
where Value: _Input & FixedWidthInteger & UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Nodes
    //=------------------------------------------------------------------------=

    public typealias Number   = _StandardID<IntegerFormatStyle<Value>         >.Style
    public typealias Currency = _CurrencyID<IntegerFormatStyle<Value>.Currency>.Style

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
    
    /// IntegerFormatStyle uses an Int; values above Int.max crash.
    @inlinable init(max  int: (some _Value & FixedWidthInteger & SignedInteger).Type) {
        self.precision = int.precision; self.max = Value(int.max)
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
// MARK: + UInt(s)
//=----------------------------------------------------------------------------=

extension UInt:   _Input { public static let _NumberTextGraph = _UInt<Self>(max:Int  .self) }
extension UInt8:  _Input { public static let _NumberTextGraph = _UInt<Self>(precision:  03) }
extension UInt16: _Input { public static let _NumberTextGraph = _UInt<Self>(precision:  05) }
extension UInt32: _Input { public static let _NumberTextGraph = _UInt<Self>(precision:  10) }
extension UInt64: _Input { public static let _NumberTextGraph = _UInt<Self>(max:Int64.self) }
