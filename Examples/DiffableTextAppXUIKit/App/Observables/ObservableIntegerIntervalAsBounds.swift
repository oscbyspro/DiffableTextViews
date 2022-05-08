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
    
    init(_ interval: Interval<Int>, map: @escaping (Interval<Int>) -> ClosedRange<Value>) {
        self.interval = Observable(interval)
        self.subscription = self.interval.$wrapped.sink {
            [unowned self]
            in values = map($0)
        }
    }
    
    @inlinable static func decimal9s(_ interval: Interval<Int>) -> Self where Value == Decimal {
        Self.init(interval) { let ordered = $0.closed
            //=--------------------------------------=
            // Single
            //=--------------------------------------=
            func bound(_ length: Int) -> Decimal {
                guard length != 0 else { return 0 }
                var description = length >= 0 ? "" : "-"
                description += String(repeating: "9", count: abs(length))
                return Decimal(string: description)!
            }
            //=--------------------------------------=
            // Double
            //=--------------------------------------=
            return bound(ordered.lowerBound)...bound(ordered.upperBound)
        }
    }
}
