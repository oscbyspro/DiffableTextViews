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

extension Decimal: Value.Signed, Value.Float, Value.Number, Value.Currency, Value.Percent {
    @usableFromInline typealias Number = FormatStyle
    @usableFromInline typealias Currency = FormatStyle.Currency
    @usableFromInline typealias Percent = FormatStyle.Percent

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(38)
    public static let bounds: ClosedRange<Self> = bounds(limit: Self(string: String(repeating: "9", count: 38))!)
}
