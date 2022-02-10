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
// MARK: * RegionTests x Lexicon
//*============================================================================*

extension RegionTests {
    typealias Lexicon<T: Hashable & CaseIterable> = Region.Lexicon<T>
    
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
