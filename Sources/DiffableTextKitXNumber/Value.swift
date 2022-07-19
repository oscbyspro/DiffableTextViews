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

public protocol _Value: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: Graph
    //=------------------------------------------------------------------------=
    
    associatedtype NumberTextGraph where NumberTextGraph: _Graph,
    NumberTextGraph: _Numberable,  NumberTextGraph.Value == Self
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable static var _NumberTextGraph: NumberTextGraph { get }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Value {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) static var min:  NumberTextGraph.Input {
        _NumberTextGraph.min
    }

    @inlinable @inline(__always) static var max:  NumberTextGraph.Input {
        _NumberTextGraph.max
    }

    @inlinable @inline(__always) static var zero: NumberTextGraph.Input {
        _NumberTextGraph.zero
    }
    
    @inlinable @inline(__always) static var precision: Int {
        _NumberTextGraph.precision
    }

    @inlinable @inline(__always) static var optional: Bool {
        _NumberTextGraph.optional
    }

    @inlinable @inline(__always) static var unsigned: Bool {
        _NumberTextGraph.unsigned
    }

    @inlinable @inline(__always) static var integer:  Bool {
        _NumberTextGraph.integer
    }
}

//*============================================================================*
// MARK: * Input
//*============================================================================*

public protocol _Input: _Value, Comparable where NumberTextGraph.Input == Self { }
