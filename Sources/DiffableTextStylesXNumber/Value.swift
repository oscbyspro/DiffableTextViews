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
// MARK: Declaration
//*============================================================================*

public protocol NumberTextKind {
    
    //=------------------------------------------------------------------------=
    // MARK: Style
    //=------------------------------------------------------------------------=
    
    associatedtype NumberTextStyle: NumberTextStyleProtocol
    typealias NumberTextFormat = NumberTextStyle.Format
    typealias NumberTextValue = NumberTextFormat.FormatInput
    
    //=------------------------------------------------------------------------=
    // MARK: Kind
    //=------------------------------------------------------------------------=
    
    @inlinable static var isOptional: Bool { get }
    @inlinable static var isUnsigned: Bool { get }
    @inlinable static var isInteger:  Bool { get }
}

//*============================================================================*
// MARK: Declaration
//*============================================================================*

public protocol NumberTextValue: Comparable, NumberTextKind {
    
    //=------------------------------------------------------------------------=
    // MARK: Zero, Precision, Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable static var zero: Self { get }
    @inlinable static var precision: Int { get }
    @inlinable static var bounds: ClosedRange<Self> { get }
}

//=----------------------------------------------------------------------------=
// MARK: Details
//=----------------------------------------------------------------------------=

public extension NumberTextValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Kind
    //=------------------------------------------------------------------------=
    
    @inlinable static var isOptional: Bool { false }
}

//*============================================================================*
// MARK: x Floating Point
//*============================================================================*

public protocol  NumberTextValueXFloatingPoint: NumberTextValue { }
public extension NumberTextValueXFloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Kind
    //=------------------------------------------------------------------------=
    
    @inlinable static var isInteger: Bool { false }

    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func bounds(abs: Self) -> ClosedRange<Self>
    where Self: SignedNumeric { -abs ... abs }
}

//*============================================================================*
// MARK: x Integer
//*============================================================================*

public protocol  NumberTextValueXInteger: NumberTextValue { }
public extension NumberTextValueXInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Kind
    //=------------------------------------------------------------------------=
    
    @inlinable static var isInteger: Bool { true }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=

    @inlinable internal static func bounds() -> ClosedRange<Self>
    where Self: FixedWidthInteger { Self.min ... Self.max }
}

//*============================================================================*
// MARK: x Signed
//*============================================================================*

public protocol  NumberTextValueXSigned: NumberTextValue { }
public extension NumberTextValueXSigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Kind
    //=------------------------------------------------------------------------=
    
    @inlinable static var isUnsigned: Bool { false }
}

//*============================================================================*
// MARK: x Unsigned
//*============================================================================*

public protocol  NumberTextValueXUnsigned: NumberTextValue { }
public extension NumberTextValueXUnsigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Kind
    //=------------------------------------------------------------------------=
    
    @inlinable static var isUnsigned: Bool { true }
}

//*============================================================================*
// MARK: x Branchables
//*============================================================================*

public protocol NumberTextValueXNumberable: NumberTextValue
where NumberTextFormat: NumberTextFormatXNumber { }

public protocol NumberTextValueXCurrencyable: NumberTextValue
where NumberTextFormat: NumberTextFormatXCurrencyable { }

public protocol NumberTextValueXPercentable:  NumberTextValue
where NumberTextFormat: NumberTextFormatXPercentable { }
