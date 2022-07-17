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

public struct _Graph_Decimal: _Graph, _Graph_Number, _Graph_Percent, _Graph_Currency {
    public typealias Value = Decimal
    public typealias Input = Decimal
    
    //=------------------------------------------------------------------------=
    // MARK: Nodes
    //=------------------------------------------------------------------------=
    
    public typealias Format   =  Decimal.FormatStyle
    public typealias Number   = _DefaultID_Standard<Format         >.Style
    public typealias Percent  = _DefaultID_Standard<Format.Percent >.Style
    public typealias Currency = _DefaultID_Currency<Format.Currency>.Style

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    public let min: Input
    public let max: Input
    public let precision: Int

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init() {
        self.precision = 38
        self.max = Input(string: String(repeating: "9", count: precision))!
        self.min = -max
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) public var zero: Input { .zero }

    @inlinable @inline(__always) public var optional: Bool { false }

    @inlinable @inline(__always) public var unsigned: Bool { false }

    @inlinable @inline(__always) public var integer:  Bool { false }
}

//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension Decimal: _Input {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public static let _numberTextGraph = _Graph_Decimal()
}
