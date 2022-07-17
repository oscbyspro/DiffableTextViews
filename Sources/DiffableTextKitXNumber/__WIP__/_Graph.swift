//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#warning("WIP")
#warning("WIP")
#warning("WIP")

//*============================================================================*
// MARK: * Graph
//*============================================================================*

public protocol _Graph {
    associatedtype Value: _Value
    associatedtype Input: _Input = Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var min:  Input    { get }
    @inlinable var max:  Input    { get }
    @inlinable var zero: Input    { get }
    @inlinable var precision: Int { get }
    
    @inlinable var optional: Bool { get }
    @inlinable var unsigned: Bool { get }
    @inlinable var integer:  Bool { get }
}

//*============================================================================*
// MARK: * Graph x Number
//*============================================================================*

public protocol _Graph_Number: _Graph {
    associatedtype Number: _Style where Number.Value == Value
}

//*============================================================================*
// MARK: * Graph x Percent
//*============================================================================*

public protocol _Graph_Percent: _Graph {
    associatedtype Percent: _Style where Percent.Value == Value
}

//*============================================================================*
// MARK: * Graph x Currency
//*============================================================================*

public protocol _Graph_Currency: _Graph {
    associatedtype Currency: _Style where Currency.Value == Value
}

#warning("WIP")
#warning("WIP")
#warning("WIP")

//NumberTextValueXSigned,
//NumberTextValueXFloatingPoint,
//NumberTextValueXNumberable,
//NumberTextValueXCurrencyable,
//NumberTextValueXPercentable { }
