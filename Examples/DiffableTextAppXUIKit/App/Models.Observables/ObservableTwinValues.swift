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
import DiffableTextViews

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class ObservableTwinValues<T>: ObservableObject where T: NumberTextValue {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    private var _standard: T  = .zero
    private var _optional: T? = .zero
    
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
        self._standard = $0 ?? .zero
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
