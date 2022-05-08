//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation
import DiffableTextViews

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class NumberScreenContext: ObservableObject {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let decimals = ObservableTwinValues(Decimal(string: "1234567.89")!)
    let optional = Observable(false)

    let format = Observable(FormatID.currency)
    let locale = Observable(Locale(identifier: "en_US"))
    let currency = Observable("USD")
    
    let bounds = ObservableIntegerIntervalAsBounds.decimal9s(Interval((0, Decimal.precision)))
    let boundsLimits = -Decimal.precision ... Decimal.precision

    let integer = Observable(Interval((1, Decimal.precision)))
    let integerLimits = 1 ... Decimal.precision
    
    let fraction = Observable(Interval((2, 2)))
    let fractionLimits = 0 ... Decimal.precision
    
    //*========================================================================*
    // MARK: Declaration
    //*========================================================================*
    
    enum FormatID: String, CaseIterable { case number, currency, percent }
}
