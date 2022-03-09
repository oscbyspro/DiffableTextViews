//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import DiffableTestKit
@testable import DiffableTextStylesXNumeric

//*============================================================================*
// MARK: * HelpersTests x Lexicon
//*============================================================================*

final class HelpersTestsXLexicon: Tests {
    
    //=------------------------------------------------------------------------=
    // MARK: Styles
    //=------------------------------------------------------------------------=
    
    @inlinable func int(_ lexicon: Lexicon) -> IntegerFormatStyle<Int> {
        .number.locale(lexicon.locale)
    }
    
    @inlinable func double(_ lexicon: Lexicon) -> FloatingPointFormatStyle<Double> {
        .number.locale(lexicon.locale)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSigns() {
        let positive: Int = +1
        let negative: Int = -1
        //=--------------------------------------=
        // MARK: Lexicons
        //=--------------------------------------=
        for lexicon in standard {
            let style = int(lexicon).sign(strategy: .always())
            let positives = positive.formatted(style)
            let negatives = negative.formatted(style)
            XCTAssertNotNil(positives.first(where: { lexicon.signs[$0] != nil }))
            XCTAssertNotNil(negatives.first(where: { lexicon.signs[$0] != nil }))
        }
    }
    
    func testDigits() {
        let number: Int = 1234567890
        //=--------------------------------------=
        // MARK: Lexicons
        //=--------------------------------------=
        for lexicon in standard {
            let style = int(lexicon).grouping(.never)
            let numbers = number.formatted(style)
            XCTAssert(numbers.allSatisfy({ lexicon.digits[$0] != nil }))
        }
    }
    
    func testGroupingSeparators() {
        let number: Int = 1234567890
        //=--------------------------------------=
        // MARK: Lexicons
        //=--------------------------------------=
        for lexicon in standard {
            let style = int(lexicon).grouping(.automatic)
            let nonnumbers = number.formatted(style).filter({ !$0.isNumber })
            XCTAssert(nonnumbers.allSatisfy({ lexicon.separators[$0] == .grouping }))
        }
    }
    
    func testFractionSeparators() {
        let number: Double = 0.123
        //=--------------------------------------=
        // MARK: Lexicons
        //=--------------------------------------=
        for lexicon in standard {
            let style = double(lexicon).decimalSeparator(strategy: .always)
            let nonnumbers = number.formatted(style).filter({ !$0.isNumber })
            XCTAssert(nonnumbers.allSatisfy({ lexicon.separators[$0] == .fraction }))
        }
    }
}

#endif
