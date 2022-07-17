//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Value
//*============================================================================*

public protocol _Value {
    associatedtype NumberTextGraph: _Graph where NumberTextGraph.Value == Self
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable static var _numberTextGraph: NumberTextGraph { get }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Value {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static var min: NumberTextGraph.Input {
        _numberTextGraph.min
    }

    @inlinable @inline(__always) static var max: NumberTextGraph.Input {
        _numberTextGraph.max
    }

    @inlinable @inline(__always) static var zero: NumberTextGraph.Input {
        _numberTextGraph.zero
    }
    
    @inlinable @inline(__always) static var precision: Int {
        _numberTextGraph.precision
    }

    @inlinable @inline(__always) static var optional: Bool {
        _numberTextGraph.optional
    }

    @inlinable @inline(__always) static var unsigned: Bool {
        _numberTextGraph.unsigned
    }

    @inlinable @inline(__always) static var integer:  Bool {
        _numberTextGraph.integer
    }
}

//*============================================================================*
// MARK: * Input
//*============================================================================*

public protocol _Input: _Value, Comparable where NumberTextGraph.Input == Self { }
