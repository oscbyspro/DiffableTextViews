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

final class Observable<Value>: ObservableObject {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @Published var wrapped: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ wrapped: Value) { self.wrapped = wrapped }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var xwrapped: Binding<Value> {
        Binding { self.wrapped } set: { self.wrapped = $0 }
    }
}

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class ObservableDecimalBounds: ObservableObject {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let interval: Observable<Interval<Int>>
    private var subscription: AnyCancellable!
    @Published var values: ClosedRange<Decimal>!

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ integers: Interval<Int>) {
        self.interval = Observable(integers)
        self.subscription = self.interval.$wrapped.sink {
            [unowned self] in values = compute($0)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    func compute(_ interval: Interval<Int>) -> ClosedRange<Decimal> {
        let ordered = interval.closed
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

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class ObservableTwinValues<T>: ObservableObject where T: Numeric {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    private var _standard: T  = 0
    private var _optional: T? = 0
    
    //=------------------------------------------------------------------------=
    // MARK: Publishers
    //=------------------------------------------------------------------------=
    
    private let __standard = PassthroughSubject<T , Never>()
    private let __optional = PassthroughSubject<T?, Never>()
    
    //=------------------------------------------------------------------------=
    // MARK: Subscriptions
    //=------------------------------------------------------------------------=
    
    private lazy var ___standard = __standard.sink {
        [unowned self] in
        self.objectWillChange.send()
        self._standard = $0
        self._optional = $0
    }
    
    private lazy var ___optional = __optional.sink {
        [unowned self] in
        self.objectWillChange.send()
        self._standard = $0 ?? 0
        self._optional = $0
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init() {
        _ = ___standard
        _ = ___optional
    }
    
    convenience init(_ value: T) {
        self.init(); self.__standard.send(value)
    }
    
    convenience init(_ value: T?) {
        self.init(); self.__optional.send(value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var standard: T  {
        get { _standard } set { __standard.send(newValue) }
    }
    
    var optional: T? {
        get { _optional } set { __optional.send(newValue) }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var xstandard: Binding<T>  {
        Binding(get: { self._standard }, set: __standard.send)
    }
    
    var xoptional: Binding<T?> {
        Binding(get: { self._optional }, set: __optional.send)
    }
}
