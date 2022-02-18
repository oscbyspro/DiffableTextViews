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
// MARK: * PercentTests
//*============================================================================*

final class PercentTests: XCTestCase {
    typealias Format = Decimal.FormatStyle.Percent
    typealias Style = NumericTextStyle<Format>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// Loops about 1k times.
    func testAllAvailableLocales() {
        let value = Decimal(string: "-1234567.89")!
        //=--------------------------------------=
        // MARK: Locales
        //=--------------------------------------=
        for locale in locales {
            let style = Style.percent.locale(locale)
            let expectation = Format.percent.locale(locale).precision(.fractionLength(0...))
            //=----------------------------------=
            // MARK: Testable
            //=----------------------------------=
            let commit = style.interpret(value: value)
            let characters = expectation.format(value)
            //=----------------------------------=
            // MARK: Value
            //=----------------------------------=
            guard commit.value == value else {
                XCTFail("\(commit.value) != \(value) ... \((locale))")
                return
            }
            //=----------------------------------=
            // MARK: Characters
            //=----------------------------------=
            guard commit.snapshot.characters == characters else {
                XCTFail("\(commit.snapshot.characters) != \(characters) ... \((locale))")
                return
            }
        }
    }
}

#endif