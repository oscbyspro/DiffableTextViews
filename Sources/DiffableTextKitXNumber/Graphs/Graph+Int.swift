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

public struct _Int<Value>: _Graph, _Numberable, _Currencyable
where Value: _Input & FixedWidthInteger & SignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Nodes
    //=------------------------------------------------------------------------=

    public typealias Number   = _StandardID<IntegerFormatStyle<Value>         >.Style
    public typealias Currency = _CurrencyID<IntegerFormatStyle<Value>.Currency>.Style

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let precision: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(precision: Int) {
        self.precision = precision
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) public var min:  Value { .min  }
    
    @inlinable @inline(__always) public var max:  Value { .max  }
    
    @inlinable @inline(__always) public var zero: Value { .zero }
    
    @inlinable @inline(__always) public var optional: Bool { false }
    
    @inlinable @inline(__always) public var unsigned: Bool { false }
    
    @inlinable @inline(__always) public var integer:  Bool { true  }
}

//=----------------------------------------------------------------------------=
// MARK: + Int
//=----------------------------------------------------------------------------=

extension Int: _Input {
    public  typealias  NumberTextGraph = _Int<Self>
    public static let _NumberTextGraph = _Int<Self>(precision: String(max).count)
}

//=----------------------------------------------------------------------------=
// MARK: + Int(s)
//=----------------------------------------------------------------------------=

extension Int8:  _Input { public static let _NumberTextGraph = _Int<Self>(precision: 03) }
extension Int16: _Input { public static let _NumberTextGraph = _Int<Self>(precision: 05) }
extension Int32: _Input { public static let _NumberTextGraph = _Int<Self>(precision: 10) }
extension Int64: _Input { public static let _NumberTextGraph = _Int<Self>(precision: 19) }
