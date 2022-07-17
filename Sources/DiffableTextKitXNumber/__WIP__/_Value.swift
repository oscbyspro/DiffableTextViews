//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#warning("Rework: NumberTextGraph.............................................")
//*============================================================================*
// MARK: * Value
//*============================================================================*

public protocol _Value {
    associatedtype NumberTextStyle: _Style
    typealias NumberTextGraph = NumberTextStyle.Graph
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable static var isOptional: Bool { get }
    @inlinable static var isUnsigned: Bool { get }
    @inlinable static var isInteger:  Bool { get }
}

//*============================================================================*
// MARK: * Value x Branchable(s)
//*============================================================================*

public protocol _Value_Numberable: _Value
where NumberTextGraph.Format: _Format_Number { }

public protocol _Value_Currencyable: _Value
where NumberTextGraph.Format: _Format_Currencyable { }

public protocol _Value_Percentable: _Value
where NumberTextGraph.Format: _Format_Percentable { }
