//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation
import XCTest

//*============================================================================*
// MARK: * StyleVsFormatterTests
//*============================================================================*

final class StyleVsFormatterTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testStyleIsMoreAccurateThanFormatter() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = true
        let style = Decimal.FormatStyle.number
        //=--------------------------------------=
        // MARK: Subject
        //=--------------------------------------=
        let content = String(repeating: "9", count: 38)
        let expectation = Decimal(string: content)!
        //=--------------------------------------=
        // MARK: Results
        //=--------------------------------------=
        XCTAssertEqual(expectation, try! style.parseStrategy.parse(content))
        XCTAssertNotEqual(expectation, formatter.number(from: content) as! Decimal)
    }
}
