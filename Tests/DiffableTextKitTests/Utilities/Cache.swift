//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import DiffableTextKit

import XCTest

//*============================================================================*
// MARK: * Cache x Tests
//*============================================================================*

final class CacheTests: XCTestCase {
    typealias Value = Box<String>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Utilities
    //=------------------------------------------------------------------------=
    
    func testObjectForCustomKey() {
        let storage = Cache<Int, Value>()
        storage.insert(Value("ABC"), as: 123)
        XCTAssertEqual(Value("ABC"), storage.access(123))
    }
}

//*============================================================================*
// MARK: * Cache x NSKey x Tests
//*============================================================================*

final class NSKeyTests: XCTestCase {
    typealias T = NSKey<Int>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Utilities
    //=------------------------------------------------------------------------=
    
    func testHash() {
        XCTAssertEqual(T(3).hash, 3.hashValue)
    }
    
    func testIsEqual() {
        XCTAssert(     T(3).isEqual(T(3)))
        XCTAssertFalse(T(3).isEqual(T(0)))
        XCTAssertFalse(T(3).isEqual([33]))
    }
}

#endif
