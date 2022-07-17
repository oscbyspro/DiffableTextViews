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

public struct _Graph_Float<Value: _Input>: _Graph, _Graph_Number, _Graph_Percent,
_Graph_Currency where Value: BinaryFloatingPoint & SignedNumeric {
    
    //=------------------------------------------------------------------------=
    // MARK: Nodes
    //=------------------------------------------------------------------------=
    
    public typealias Format   =  FloatingPointFormatStyle<Value>
    public typealias Number   = _DefaultID_Standard<Format         >.Style
    public typealias Percent  = _DefaultID_Standard<Format.Percent >.Style
    public typealias Currency = _DefaultID_Currency<Format.Currency>.Style

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    public let min: Value
    public let max: Value
    public let precision: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(precision: Int) {
        let _abs = String(repeating: "9", count: precision)
        let  abs = try! Value(_abs, format: Format(locale: .en_US_POSIX))
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

extension Double: _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public typealias   NumberTextGraph = _Graph_Float<Self>
    public static let _numberTextGraph = _Graph_Float<Self>(precision: 15)
}
