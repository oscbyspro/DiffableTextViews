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
// MARK: * Graph x Integer
//*============================================================================*

public final class _IntegerGraph<Value>: _Graph, _Numberable, _Currencyable
where Value: _Input & FixedWidthInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Nodes
    //=------------------------------------------------------------------------=
    
    public typealias Number   = _StandardStyle<IntegerFormatStyle<Value>         >
    public typealias Currency = _CurrencyStyle<IntegerFormatStyle<Value>.Currency>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let min: Value
    public let max: Value
    public let precision: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// - Max `Int.precision` due to `IntegerFormatStyle`.
    fileprivate init() {
        let large = Value.bitWidth >= Int.bitWidth
        self.max = large  ? Value(Int.max) : Value.max
        self.min = large && Value.isSigned ? Value(Int.min) : Value.min
        self.precision = Int(ceil(log10(Double(max))))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public var zero: Value { .zero }
    
    @inlinable @inline(__always) public var optional: Bool { false }
    
    @inlinable @inline(__always) public var unsigned: Bool { !Value.isSigned }
    
    @inlinable @inline(__always) public var integer:  Bool { true  }
}

//=----------------------------------------------------------------------------=
// MARK: + Int(s)
//=----------------------------------------------------------------------------=

extension Int:   _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
extension Int8:  _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
extension Int16: _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
extension Int32: _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
extension Int64: _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }

//=----------------------------------------------------------------------------=
// MARK: + UInt(s)
//=----------------------------------------------------------------------------=

extension UInt:   _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
extension UInt8:  _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
extension UInt16: _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
extension UInt32: _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
extension UInt64: _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
