//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI

//*============================================================================*
// MARK: * Screen x Number x Context
//*============================================================================*

final class NumberScreenContext: ObservableObject {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @Observable var kind = KindID.standard
    @Observable var format = FormatID.currency
    @Observable var locale = Locale(identifier: "en_US")
    @Observable var currency = "USD"
    
    @Observable var bounds   = Bounds((0, p))
    @Observable var integer  = (1, p)
    @Observable var fraction = (2, 2)
    
    @Observable var decimals = Twins(Decimal(string: "1234567.89")!)
    
    let boundsLimits   = -p ... p
    let integerLimits  =  1 ... p
    let fractionLimits =  0 ... p
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    static var p: Int { Decimal._NumberTextGraph.precision }
    
    //*========================================================================*
    // MARK: * ID(s)
    //*========================================================================*
    
    enum KindID: String, CaseIterable {
        case standard, optional
    }
    
    enum FormatID: String, CaseIterable {
        case number, currency, percent
    }
}
