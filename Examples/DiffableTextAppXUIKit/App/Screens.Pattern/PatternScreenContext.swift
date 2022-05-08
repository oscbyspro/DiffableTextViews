//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Combine

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class PatternScreenContext: ObservableObject {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let value = Observable("123456789")
    let pattern = Observable(PatternID.phone)
    let visibility = Observable(VisibilityID.visible)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func popLast() {
        _ = value.wrapped.popLast()
    }
    
    func appendASCIIDigit() {
        Self.digits.randomElement().map({ value.wrapped.append($0) })
    }
    
    func appendUppercased() {
        Self.uppercased.randomElement().map({ value.wrapped.append($0) })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    static let digits: String = "0123456789"
    static let uppercased: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    //*========================================================================*
    // MARK: Kind
    //*========================================================================*
    
    enum PatternID: String, CaseIterable {
        case phone, card
    }
    
    enum VisibilityID: String, CaseIterable {
        case visible, hidden
    }
}
