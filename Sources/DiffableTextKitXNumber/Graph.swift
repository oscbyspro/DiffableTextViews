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
// MARK: * Graph
//*============================================================================*

public protocol _Graph {
    
    associatedtype Value: _Value // where Value.NumberTextGraph == Self
    
    associatedtype Input: _Input
    
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
// MARK: * Graph x Numberable
//*============================================================================*

public protocol _Numberable: _Graph {
    associatedtype Number: _Style where
    Number:     _Standard,
    Number.Value == Value,
    Number.Input == Input
}

//*============================================================================*
// MARK: * Graph x Percentable
//*============================================================================*

public protocol _Percentable: _Graph {
    associatedtype Percent: _Style where
    Percent:     _Standard,
    Percent.Value == Value,
    Percent.Input == Input
}

public extension _Style where Graph: _Percentable, Graph: _Numberable, Graph.Number == Self {
    typealias Percent = Graph.Percent
}

//*============================================================================*
// MARK: * Graph x Currency
//*============================================================================*

public protocol _Currencyable: _Graph {
    associatedtype Currency: _Style where
    Currency:     _Currency,
    Currency.Value == Value,
    Currency.Input == Input
}

public extension _Style where Graph: _Currencyable, Graph: _Numberable, Graph.Number == Self {
    typealias Currency = Graph.Currency
}
