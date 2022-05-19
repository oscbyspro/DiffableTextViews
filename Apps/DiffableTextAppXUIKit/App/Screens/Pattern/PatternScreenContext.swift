//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI
import DiffableTextViews

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class PatternScreenContext: ObservableObject {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @Observable var pattern = PatternID.phone
    @Observable var visibility = VisibilityID.visible
    @Observable var value = "123456789"
    
    let phone = pattern("+## (###) ###-##-##")
    let card  = pattern("#### #### #### ####")
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    func popLast() {
        _ = value.popLast()
    }
    
    func appendDigit() {
        value.append(Character.random(in: "0" ... "9")!)
    }
    
    func appendLetter() {
        value.append(Character.random(in: "A" ... "Z")!)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    static func pattern(_ pattern: String) -> PatternTextStyle<String> {
        .pattern(pattern).placeholder("#") { $0.isASCII && $0.isNumber }
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
