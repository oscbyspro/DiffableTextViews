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
@testable import DiffableTextKit

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class UtilitiesTestsXCache: XCTestCase {
    typealias Value = Box<String>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testObjectForCustomKey() {
        let storage = Cache<Int, Value>()
        storage.insert(Value("ABC"), as: 123)
        XCTAssertEqual(Value("ABC"), storage.access(123))
    }
}

#endif
