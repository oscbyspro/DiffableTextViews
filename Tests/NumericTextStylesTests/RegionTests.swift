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

@testable import NumericTextStyles

//*============================================================================*
// MARK: * RegionTests
//*============================================================================*

final class RegionTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var locales: [Locale] = Locale
        .availableIdentifiers
        .lazy.map(Locale.init)
    
    lazy var regions: [Region] = locales
        .compactMap({ try? Region($0) })
    
    lazy var currencies: [String] = locales
        .lazy.compactMap(\.currencyCode)
        .reduce(into: Set()) { $0.insert($1) }
        .map({ $0 })
}

//=----------------------------------------------------------------------------=
// MARK: + Assumptions
//=----------------------------------------------------------------------------=

extension RegionTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testVirtualCharactersAreNotAlwaysUnique() {
        let number = 1234567.89
        let currencyCode = "PAB"
        let locale = Locale(identifier: "rhg-Rohg_MM")
        let formatted = number.formatted(.currency(code: currencyCode).locale(locale))
        XCTAssertEqual(formatted, "B/. 1,234,567.89") // currency contains fraction separator
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Instances
//=----------------------------------------------------------------------------=

extension RegionTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
        
    func testEachLocaleMapsToARegion() {
        XCTAssertEqual(regions.count, locales.count)
    }
    
    func testThatThereAreManyRegions() {
        XCTAssertGreaterThanOrEqual(regions.count, 937)
    }
    
    func testThatThereAreManyCurrencies() {
        XCTAssertGreaterThanOrEqual(currencies.count, 153)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Lexicon
//=----------------------------------------------------------------------------=

extension RegionTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    /// Asserts that all components are bidirectionally mapped to a character.
    func testCharacterComponentLinks() {
        func test<Component: Hashable & CaseIterable>(lexicon: Lexicon<Component>) {
            for component in Component.allCases {
                let character = lexicon[component]
                let localized = lexicon[character]
                XCTAssertEqual(component, localized)
            }
        }
        //=--------------------------------------=
        // MARK: Regions
        //=--------------------------------------=
        for region in regions {
            test(lexicon: region.signs)
            test(lexicon: region.digits)
            test(lexicon: region.separators)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Components
//=----------------------------------------------------------------------------=

extension RegionTests {

    //=------------------------------------------------------------------------=
    // MARK: Styles
    //=------------------------------------------------------------------------=
    
    @inlinable func int(_ region: Region) -> IntegerFormatStyle<Int> {
        .number.locale(region.locale)
    }
    
    @inlinable func double(_ region: Region) -> FloatingPointFormatStyle<Double> {
        .number.locale(region.locale)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSigns() {
        let positive: Int = +1
        let negative: Int = -1
        //=--------------------------------------=
        // MARK: Regions
        //=--------------------------------------=
        for region in regions {
            let style = int(region).sign(strategy: .always())
            let positives = positive.formatted(style)
            let negatives = negative.formatted(style)
            XCTAssertNotNil(positives.first(where: { region.signs[$0] != nil }))
            XCTAssertNotNil(negatives.first(where: { region.signs[$0] != nil }))
        }
    }
    
    func testDigits() {
        let number: Int = 1234567890
        //=--------------------------------------=
        // MARK: Regions
        //=--------------------------------------=
        for region in regions {
            let style = int(region).grouping(.never)
            let numbers = number.formatted(style)
            XCTAssert(numbers.allSatisfy({ region.digits[$0] != nil }))
        }
    }
    
    func testGroupingSeparators() {
        let number: Int = 1234567890
        //=--------------------------------------=
        // MARK: Regions
        //=--------------------------------------=
        for region in regions {
            let style = int(region).grouping(.automatic)
            let nonnumbers = number.formatted(style).filter({ !$0.isNumber })
            XCTAssert(nonnumbers.allSatisfy({ region.separators[$0] == .grouping }))
        }
    }
    
    func testFractionSeparators() {
        let number: Double = 0.123
        //=--------------------------------------=
        // MARK: Regions
        //=--------------------------------------=
        for region in regions {
            let style = double(region).decimalSeparator(strategy: .always)
            let nonnumbers = number.formatted(style).filter({ !$0.isNumber })
            XCTAssert(nonnumbers.allSatisfy({ region.separators[$0] == .fraction }))
        }
    }
}

#endif
