//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

#warning("Rename as Input, maybe?")
//*============================================================================*
// MARK: * Value
//*============================================================================*

public protocol _Value: Comparable, _Kind {
    
    //=------------------------------------------------------------------------=
    // MARK: Zero, Precision, Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable static var zero: Self { get }
    @inlinable static var precision: Int { get }
    @inlinable static var bounds: ClosedRange<Self> { get }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

public extension _Value {
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable static var isOptional: Bool { false }
}

//*============================================================================*
// MARK: * Value x Float
//*============================================================================*

public protocol  _Value_Float: _Value { }
public extension _Value_Float {
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable static var isInteger: Bool { false }

    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func bounds(abs: Self) -> ClosedRange<Self>
    where Self: SignedNumeric { -abs ... abs }
}

//*============================================================================*
// MARK: * Value x Integer
//*============================================================================*

public protocol  _Value_Integer: _Value { }
public extension _Value_Integer {
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable static var isInteger: Bool { true }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=

    @inlinable internal static func bounds() -> ClosedRange<Self>
    where Self: FixedWidthInteger { Self.min ... Self.max }
}

//*============================================================================*
// MARK: * Value x Signed
//*============================================================================*

public protocol  _Value_Signed: _Value { }
public extension _Value_Signed {
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable static var isUnsigned: Bool { false }
}

//*============================================================================*
// MARK: * Value x Unsigned
//*============================================================================*

public protocol  _Value_Unsigned: _Value { }
public extension _Value_Unsigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable static var isUnsigned: Bool { true }
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
