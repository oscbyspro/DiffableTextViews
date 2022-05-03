//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Combine
import Foundation
import SwiftUI

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class NumericScreenContext: ObservableObject {
    typealias This = NumericScreenContext
    typealias Value = Decimal
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let value = Source(Value(string: "1234567.89")!)
    let kind = Source(Kind.currency)
    
    let currency = Source("USD")
    let locale = Source(Locale(identifier: "en_US"))
    
    let bounds = SourceOfBounds(Interval((0, This.boundsLimit)))
    let integer = Source(This.integerLimits)
    let fraction = Source(Interval((2, 2)))
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    static let boundsLimit = Value.precision
    static let boundsLimits = Interval((-boundsLimit, boundsLimit))
    static let integerLimits = Interval((1, Value.precision))
    static let fractionLimits = Interval((0, Value.precision))
    
    //*========================================================================*
    // MARK: Kind
    //*========================================================================*
    
    enum Kind: String, CaseIterable { case number, currency, percent }
}
