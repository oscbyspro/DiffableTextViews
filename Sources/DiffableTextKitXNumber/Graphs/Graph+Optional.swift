//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * Optional x Graph
//*============================================================================*

public struct _OptionalGraph<Base: _Graph>: _Graph where Base.Input == Base.Value {
    public typealias Value = Base.Value?
    public typealias Input = Base.Input
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: Base
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) init(_ base: Base) { self.base = base }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public var min:  Input { base.min  }
    
    @inlinable @inline(__always) public var max:  Input { base.max  }
    
    @inlinable @inline(__always) public var zero: Input { base.zero }
    
    @inlinable @inline(__always) public var precision: Int { base.precision }
    
    @inlinable @inline(__always) public var optional: Bool { true }
    
    @inlinable @inline(__always) public var unsigned: Bool { base.unsigned }
    
    @inlinable @inline(__always) public var integer:  Bool { base.integer  }
}

//=----------------------------------------------------------------------------=
// MARK: + Nodes
//=----------------------------------------------------------------------------=

extension _OptionalGraph: _Numberable
where Base: _Numberable, Base.Number: NullableTextStyle {
    public typealias Number = _OptionalStyle<Base.Number>
}

extension _OptionalGraph: _Percentable
where Base: _Percentable, Base.Percent: NullableTextStyle {
    public typealias Percent = _OptionalStyle<Base.Percent>
}

extension _OptionalGraph: _Currencyable
where Base: _Currencyable, Base.Currency: NullableTextStyle {
    public typealias Currency = _OptionalStyle<Base.Currency>
}

//=----------------------------------------------------------------------------=
// MARK: + Optional(s) [...]
//=----------------------------------------------------------------------------=

extension Optional: _Value where Wrapped: _Input {
    @inlinable public static var _NumberTextGraph: _OptionalGraph
    <Wrapped.NumberTextGraph> { .init(Wrapped._NumberTextGraph) }
}
