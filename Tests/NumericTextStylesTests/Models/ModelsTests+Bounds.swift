//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import XCTest
@testable import NumericTextStyles

//*============================================================================*
// MARK: * ModelsTests x Bounds
//*============================================================================*

final class ModelsTestsXBounds: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAutocorrectSign(_ bounds: (Int, Int), positive: Sign, negative: Sign) {
        let bounds = Bounds(min: bounds.0, max: bounds.1)
        XCTAssertEqual(positive, Sign.positive.transform(bounds.autocorrect))
        XCTAssertEqual(negative, Sign.negative.transform(bounds.autocorrect))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAutocorrectSign() {
        XCTAutocorrectSign((-1, 1), positive: .positive, negative: .negative) // unchanged
        XCTAutocorrectSign((-1, 0), positive: .negative, negative: .negative) // negatives
        XCTAutocorrectSign(( 0, 1), positive: .positive, negative: .positive) // positives
        XCTAutocorrectSign(( 0, 0), positive: .positive, negative: .positive) // positives
    }
}

#endif
