//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import DiffableTextKitXNumber

import XCTest

//*============================================================================*
// MARK: * Reader x Links
//*============================================================================*

final class ReaderTestsXLinks: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssertEachIsBidirectionallyLinked<T>(_ links: Links<T>) {
        for component in T.allCases {
            XCTAssertEqual(component, links[links[component]])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testEachIsBidirectionallyLinked() {
        //=--------------------------------------=
        // Components
        //=--------------------------------------=
        for components in standards.lazy.map(\.reader.components) {
            XCTAssertEachIsBidirectionallyLinked(components.signs)
            XCTAssertEachIsBidirectionallyLinked(components.digits)
            XCTAssertEachIsBidirectionallyLinked(components.separators)
        }
    }
}

#endif