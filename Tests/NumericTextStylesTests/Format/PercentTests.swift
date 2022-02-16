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
import Support
import XCTest

@testable import NumericTextStyles

//*============================================================================*
// MARK: * PercentTests
//*============================================================================*

final class PercentTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Assumptions - Positive
    //=------------------------------------------------------------------------=
    
    func testVirtualPercentCharactersAreAlwaysUnique() {
        let style = IntegerFormatStyle<Int>.Percent()
        //=--------------------------------------=
        // MARK: Locales
        //=--------------------------------------=
        for region in regions {
            let zero = style.locale(region.locale).format(0)
            //=----------------------------------=
            // MARK: Failure
            //=----------------------------------=
            guard zero.count(where: region.nonvirtual) == 1 else {
                XCTFail("\(zero), \(region.locale)")
                return
            }
        }
    }
}

#endif
