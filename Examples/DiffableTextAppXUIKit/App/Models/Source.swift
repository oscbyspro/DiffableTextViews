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
// MARK: * Source
//*============================================================================*

final class Source<Value>: ObservableObject {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @Published var content: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ storage: Value) { self.content = storage }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// Uses strong references.
    var binding: Binding<Value> {
        Binding { self.content } set: { self.content = $0 }
    }
}

//*============================================================================*
// MARK: * Source x Bounds
//*============================================================================*

final class SourceOfBounds: ObservableObject {
    typealias Integers = Interval<Int>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let interval: Source<Integers>
    private var subscription: AnyCancellable!
    @Published var values: ClosedRange<Decimal>!

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ integers: Integers) {
        self.interval = Source(integers)
        self.subscription = self.interval.$content.sink {
            [unowned self] in self.values = Self.values($0)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    static func values(_ interval: Integers) -> ClosedRange<Decimal> {
        let ordered = interval.closed
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        func bound(_ length: Int) -> Decimal {
            guard length != 0 else { return 0 }
            var description = length >= 0 ? "" : "-"
            description += String(repeating: "9", count: abs(length))
            return Decimal(string: description)!
        }
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        return bound(ordered.lowerBound)...bound(ordered.upperBound)
    }
}
