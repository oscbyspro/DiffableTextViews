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
// MARK: * Graph x Float
//*============================================================================*

public struct _Float<Value>: _Graph, _Numberable, _Percentable, _Currencyable
where Value: _Input & BinaryFloatingPoint & SignedNumeric {
    
    //=------------------------------------------------------------------------=
    // MARK: Nodes
    //=------------------------------------------------------------------------=
    
    public typealias Number   = _StandardID<FloatingPointFormatStyle<Value>         >.Style
    public typealias Percent  = _StandardID<FloatingPointFormatStyle<Value>.Percent >.Style
    public typealias Currency = _CurrencyID<FloatingPointFormatStyle<Value>.Currency>.Style

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    public let min: Value
    public let max: Value
    public let precision: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(precision: Int) where Value: LosslessStringConvertible {
        let  abs = Value(String(repeating: "9", count: precision))!
        self.precision = precision; self.min = -abs; self.max = abs
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) public var zero: Value { .zero }
    
    @inlinable @inline(__always) public var optional: Bool { false }
    
    @inlinable @inline(__always) public var unsigned: Bool { false }
    
    @inlinable @inline(__always) public var integer:  Bool { false }
}

//=----------------------------------------------------------------------------=
// MARK: + Double
//=----------------------------------------------------------------------------=

extension Double: _Input { public static let _NumberTextGraph = _Float<Self>(precision: 15) }
