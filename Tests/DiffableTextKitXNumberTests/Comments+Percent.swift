//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import DiffableTextKitXNumber

import XCTest

//*============================================================================*
// MARK: * Comments x Percent
//*============================================================================*

final class CommentsOnPercent: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testPercentLabelsAreAlwaysVirtual() {
        for cache in numbers {
            let  components = cache.interpreter.components
            func nonvirtual(character:Character) -> Bool {
                components.signs     [character] !=  nil ||
                components.digits    [character] !=  nil ||
                components.separators[character] == .fraction
            }
            
            let locale  = cache.style.locale
            let percent = IntegerFormatStyle<Int>.Percent(locale: locale)
            XCTAssertEqual(1, percent.format(0).filter(nonvirtual).count)
        }
    }
}

#endif
