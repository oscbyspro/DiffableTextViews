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
// MARK: * Graph x Decimal
//*============================================================================*

public struct _DecimalGraph: _Graph, _Numberable, _Percentable, _Currencyable {
    public typealias Value = Decimal
    public typealias Input = Decimal
    
    //=------------------------------------------------------------------------=
    // MARK: Nodes
    //=------------------------------------------------------------------------=
    
    public typealias Number   = _StandardID<Value.FormatStyle         >.Style
    public typealias Percent  = _StandardID<Value.FormatStyle.Percent >.Style
    public typealias Currency = _CurrencyID<Value.FormatStyle.Currency>.Style

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let min: Value
    public let max: Value
    public let precision: Int

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init() {
        self.precision = 38
        self.max = Value(string: String(repeating: "9", count: precision))!
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
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension Decimal: _Input { public static let _NumberTextGraph = _DecimalGraph() }
