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
// MARK: + Percent
//*============================================================================*

extension Assumptions {
    
    //=------------------------------------------------------------------------=
    // MARK: Positive
    //=------------------------------------------------------------------------=
    
    func testVirtualPercentCharactersAreAlwaysUnique() throws {
        try XCTSkipUnless(!skippable)
        let style = IntegerFormatStyle<Int>.Percent()
        //=--------------------------------------=
        // MARK: Locales
        //=--------------------------------------=
        for lexicon in standard {
            let zero = style.locale(lexicon.locale).format(0)
            //=----------------------------------=
            // MARK: Failure
            //=----------------------------------=
            guard zero.count(where: lexicon.nonvirtual) == 1 else {
                XCTFail("\(zero), \(lexicon.locale)")
                return
            }
        }
    }
}

#endif
