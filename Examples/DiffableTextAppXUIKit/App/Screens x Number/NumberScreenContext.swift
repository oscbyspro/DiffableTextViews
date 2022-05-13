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
    
    @Observable var decimals = Twins(Decimal(string: "1234567.89")!)
    @Observable var optionality = OptionalityID.standard

    @Observable var format = FormatID.currency
    @Observable var locale = Locale(identifier: "en_US")
    @Observable var currency = "USD"
    
    let bounds = ObservableIntegersAsBounds(Interval((0, Decimal.precision)))
    let boundsLimits = -Decimal.precision ... Decimal.precision

    @Observable var integer = Interval((1, Decimal.precision))
    let integerLimits = 1 ... Decimal.precision
    
    @Observable var fraction = Interval((2, 2))
    let fractionLimits = 0 ... Decimal.precision
    
    //*========================================================================*
    // MARK: Declaration
    //*========================================================================*
    
    enum FormatID: String, CaseIterable {
        case number, currency, percent
    }
    
    enum OptionalityID: String, CaseIterable {
        case standard, optional
    }
}
