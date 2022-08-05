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
            let components = cache.interpreter.components
            let percent = IntegerFormatStyle<Int>.Percent(locale:cache.style.locale)
            XCTAssertEqual(1, percent.format(0).filter(components.nonvirtual).count)
        }
    }
}

#endif
