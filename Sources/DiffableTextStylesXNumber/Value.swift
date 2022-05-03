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

public protocol NumberTextValue: Comparable {
    associatedtype NumberTextFormat:
    DiffableTextStylesXNumber.NumberTextFormat
    where NumberTextFormat.FormatInput == Self
    
    //=------------------------------------------------------------------------=
    // MARK: Requirements
    //=------------------------------------------------------------------------=
    
    @inlinable static var isInteger:  Bool { get }
    @inlinable static var isUnsigned: Bool { get }
    
    @inlinable static var zero: Self { get }
    @inlinable static var precision: Int { get }
    @inlinable static var bounds: ClosedRange<Self> { get }
}

//*============================================================================*
// MARK: x Floating Point
//*============================================================================*

public protocol  NumberTextValueXFloatingPoint: NumberTextValue { }
public extension NumberTextValueXFloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Requirements
    //=------------------------------------------------------------------------=
    
    @inlinable static var isInteger: Bool { false }

    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func bounds(max: Self) -> ClosedRange<Self>
    where Self: SignedNumeric { -max ... max }
}

//*============================================================================*
// MARK: x Integer
//*============================================================================*

public protocol  NumberTextValueXInteger: NumberTextValue { }
public extension NumberTextValueXInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Requirements
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
    // MARK: Requirements
    //=------------------------------------------------------------------------=
    
    @inlinable static var isUnsigned: Bool { false }
}

//*============================================================================*
// MARK: x Unsigned
//*============================================================================*

public protocol  NumberTextValueXUnsigned: NumberTextValue { }
public extension NumberTextValueXUnsigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Requirements
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
