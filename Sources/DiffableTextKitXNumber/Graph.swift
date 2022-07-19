//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Graph
//*============================================================================*

public protocol _Graph {
    associatedtype Input: _Input = Value
    associatedtype Value: _Value = Input
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var min:  Input { get }
    
    @inlinable var max:  Input { get }
    
    @inlinable var zero: Input { get }
    
    @inlinable var precision: Int { get }
    
    @inlinable var optional: Bool { get }
    
    @inlinable var unsigned: Bool { get }
    
    @inlinable var integer:  Bool { get }
}

//*============================================================================*
// MARK: * Graph x Nodes
//*============================================================================*

public protocol _Numberable: _Graph {
    associatedtype Number: _Style where
    Number:     _Standard,
    Number.Input == Input,
    Number.Value == Value
}

public protocol _Percentable: _Graph {
    associatedtype Percent: _Style where
    Percent:     _Standard,
    Percent.Input == Input,
    Percent.Value == Value
}

public protocol _Currencyable: _Graph {
    associatedtype Currency: _Style where
    Currency:     _Currency,
    Currency.Input == Input,
    Currency.Value == Value
}

//*============================================================================*
// MARK: * Graph x Nodes x Style
//*============================================================================*

extension _Style where Graph: _Percentable,
Graph: _Numberable, Graph.Number == Self {
    public typealias Percent = Graph.Percent
}

extension _Style where Graph: _Currencyable,
Graph: _Numberable, Graph.Number == Self {
    public typealias Currency = Graph.Currency
}
