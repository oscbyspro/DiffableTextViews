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
// MARK: * Decimal
//*============================================================================*

extension Decimal: Values.Signed, Values.FloatingPoint,
Values.Numberable, Values.Currencyable, Values.Percentable {

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(38)
    public static let bounds: ClosedRange<Self> = bounds(Self(string: String(repeating: "9", count: 38))!)
}

//*============================================================================*
// MARK: * Double
//*============================================================================*

extension Double: Values.Signed, Values.FloatingPoint,
Values.Numberable, Values.Currencyable, Values.Percentable {
    public typealias FormatStyle = FloatingPointFormatStyle<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(15)
    public static let bounds: ClosedRange<Self> = bounds(999_999_999_999_999)
}
