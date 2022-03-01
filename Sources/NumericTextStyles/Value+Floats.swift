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
// MARK: * Float x Protocol
//*============================================================================*

@usableFromInline protocol NumericTextValue_Float:
BinaryFloatingPoint, Values.Signed, Values.FloatingPoint,
Values.Numberable, Values.Currencyable, Values.Percentable where
FormatStyle == FloatingPointFormatStyle<Self> { }

//*============================================================================*
// MARK: * Double
//*============================================================================*

extension Double: NumericTextValue_Float {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(15)
    public static let bounds: ClosedRange<Self> = bounds(999_999_999_999_999)
}
