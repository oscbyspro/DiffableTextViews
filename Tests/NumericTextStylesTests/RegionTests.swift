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
}

//=----------------------------------------------------------------------------=
// MARK: + Instances
//=----------------------------------------------------------------------------=

extension RegionTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Count
    //=------------------------------------------------------------------------=
        
    func testEachLocaleMapsToARegion() {
        XCTAssertEqual(regions.count, locales.count)
    }
    
    func testThatThereAreManyRegions() {
        XCTAssertGreaterThanOrEqual(regions.count, 937)
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

//=----------------------------------------------------------------------------=
// MARK: + Lexicon
//=----------------------------------------------------------------------------=

extension RegionTests {
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// Asserts that all relevant ASCII characters are mapped to a component.
    func testASCII() {
        func test<Component: Hashable>(lexicon: Lexicon<Component>, ascii: String) {
            for character in ascii {
                XCTAssertNotNil(lexicon[character])
            }
        }
        //=--------------------------------------=
        // MARK: Regions
        //=--------------------------------------=
        for region in regions {
            test(lexicon: region.signs,      ascii: "+-")
            test(lexicon: region.digits,     ascii: "0123456789")
            test(lexicon: region.separators, ascii: ".,")
        }
    }
    
    /// Asserts that all components are bidirectionally mapped to a character.
    func testBidirectionalMaps() {
        func test<Component: Hashable & CaseIterable>(lexicon: Lexicon<Component>) {
            for component in Component.allCases {
                let character = lexicon[component]
                let xxxxxxxxx = lexicon[character]
                XCTAssertEqual(component, xxxxxxxxx)
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

#endif
