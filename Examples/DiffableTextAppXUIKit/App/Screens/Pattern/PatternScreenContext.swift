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
// MARK: Declaration
//*============================================================================*

final class PatternScreenContext: ObservableObject {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @Observable var value = "123456789"
    @Observable var pattern = PatternID.phone
    @Observable var visibility = VisibilityID.visible
    
    let digits:  String = "0123456789"
    let letters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func popLast() {
        _ = value.popLast()
    }
    
    func appendASCIIDigit() {
        value.append(digits.randomElement()!)
    }
    
    func appendLetter() {
        value.append(letters.randomElement()!)
    }

    //*========================================================================*
    // MARK: Enumerations
    //*========================================================================*
    
    enum PatternID: String, CaseIterable {
        case phone, card
    }
    
    enum VisibilityID: String, CaseIterable {
        case visible, hidden
    }
}
