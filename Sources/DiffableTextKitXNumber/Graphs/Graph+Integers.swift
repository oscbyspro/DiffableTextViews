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
    
    public typealias Number   = _StandardStyle<IntegerFormatStyle<Value>>
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
    
    /// - Limited by Int.max due to IntegerFormatStyle.
    /// - Limited by the longest representable sequence of 9s due to IntegerFormatStyle.
    fileprivate init() {
        self.precision = Int(log10(Double(Value(clamping: Int.max))))
        self.max = Value(String(repeating: "9", count: self.precision))!
        self.min = Value(clamping: -1) * self.max // zero when unsigned
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public var zero:    Value { .zero }
    
    @inlinable @inline(__always) public var optional: Bool { false }
    
    @inlinable @inline(__always) public var unsigned: Bool { !Value.isSigned }
    
    @inlinable @inline(__always) public var integer:  Bool { true  }
}

//=----------------------------------------------------------------------------=
// MARK: + Int(s) [...]
//=----------------------------------------------------------------------------=

extension Int:   _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
extension Int8:  _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
extension Int16: _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
extension Int32: _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
extension Int64: _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }

//=----------------------------------------------------------------------------=
// MARK: + UInt(s) [...]
//=----------------------------------------------------------------------------=

extension UInt:   _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
extension UInt8:  _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
extension UInt16: _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
extension UInt32: _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
extension UInt64: _Input { public static let _NumberTextGraph = _IntegerGraph<Self>() }
