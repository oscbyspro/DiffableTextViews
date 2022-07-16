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
// MARK: * Input
//*============================================================================*

public protocol _Input: Comparable, _Value {
    
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

public extension _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable static var isOptional: Bool { false }
}

//*============================================================================*
// MARK: * Input x Float
//*============================================================================*

public protocol  _Input_Float: _Input { }
public extension _Input_Float {
    
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
// MARK: * Input x Integer
//*============================================================================*

public protocol  _Input_Integer: _Input { }
public extension _Input_Integer {
    
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
// MARK: * Input x Signed
//*============================================================================*

public protocol  _Input_Signed: _Input { }
public extension _Input_Signed {
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable static var isUnsigned: Bool { false }
}

//*============================================================================*
// MARK: * Input x Unsigned
//*============================================================================*

public protocol  _Input_Unsigned: _Input { }
public extension _Input_Unsigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable static var isUnsigned: Bool { true }
}
