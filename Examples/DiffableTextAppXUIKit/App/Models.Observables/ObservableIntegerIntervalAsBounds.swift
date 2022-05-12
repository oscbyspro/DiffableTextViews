//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Combine
import SwiftUI

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class ObservableIntegerIntervalAsBounds<Value: Comparable>: ObservableObject {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @Published var values: ClosedRange<Value>!
    let interval: Observable<Interval<Int>>
    private var subscription: AnyCancellable!
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    convenience init(_ interval: Interval<Int>) where Value == Decimal {
        self.init(interval) {
            Decimal(string: String.number(nines: $0))!
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    private init(_ interval: Interval<Int>, map: @escaping (Int) -> Value) {
        //=--------------------------------------=
        // Interval
        //=--------------------------------------=
        self.interval = Observable(interval)
        //=--------------------------------------=
        // Converter
        //=--------------------------------------=
        self.subscription = self.interval.$wrapped.sink {
            [unowned self] interval in let closed = interval.closed
            values = map(closed.lowerBound)...map(closed.upperBound)
        }
    }
}
