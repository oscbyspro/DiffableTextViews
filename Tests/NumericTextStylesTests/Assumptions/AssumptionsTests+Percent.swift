//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import Foundation
import XCTest
import XCTestSupport

@testable import NumericTextStyles

//*============================================================================*
// MARK: * AssumptionsTests x Percent
//*============================================================================*

final class AssumptionsTestsXPercent: Tests {
    
    //=------------------------------------------------------------------------=
    // MARK: Positive
    //=------------------------------------------------------------------------=
    
    func testVirtualPercentCharactersAreAlwaysUnique() throws {
        //=--------------------------------------=
        // MARK: Locales
        //=--------------------------------------=
        for lexicon in standard {
            let zero = IntegerFormatStyle<Int>.Percent(locale: lexicon.locale).format(0)
            XCTAssert(zero.count(where: lexicon.nonvirtual) == 1, "\(zero), \(lexicon.locale)")
        }
    }
}

#endif
