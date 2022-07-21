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

public final class _FloatGraph<Value>: _Graph, _Numberable, _Percentable, _Currencyable
where Value: _Input & BinaryFloatingPoint & SignedNumeric {
    
    //=------------------------------------------------------------------------=
    // MARK: Nodes
    //=------------------------------------------------------------------------=
    
    public typealias Number   = _StandardStyle<FloatingPointFormatStyle<Value>         >
    public typealias Percent  = _StandardStyle<FloatingPointFormatStyle<Value>.Percent >
    public typealias Currency = _CurrencyStyle<FloatingPointFormatStyle<Value>.Currency>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    public let min: Value
    public let max: Value
    public let precision: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// - Max `Double.precision` due to `FloatingPointFormatStyle`.
    fileprivate init() where Value: LosslessStringConvertible {
        let size = Swift.min(Value.significandBitCount, Double.significandBitCount)
        self.precision = Int(log10(pow(2, Double(size))))
        self.max = Value(String(repeating: "9", count: precision))!
        self.min = -(max)
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

extension Double: _Input { public static let _NumberTextGraph = _FloatGraph<Self>() }
