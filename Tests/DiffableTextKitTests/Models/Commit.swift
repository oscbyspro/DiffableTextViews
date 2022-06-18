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
// MARK: * Commit x Tests
//*============================================================================*

final class CommitTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInitOptionalIsNil() {
        let commit = Commit<Int?>()
        XCTAssertEqual(commit.value,  nil)
        XCTAssert(commit.snapshot.isEmpty)
    }
    
    func testInitOptionalIsEqualToNonoptionalArgument() {
        let nonoptional = Commit<Int>(3, Snapshot("3"))
        let optional = Commit<Optional<Int>>(nonoptional)
        XCTAssertEqual(optional.value, nonoptional.value)
        XCTAssertEqual(optional.snapshot, nonoptional.snapshot)
    }

    func testInitRangeReplaceableCollectionIsEmpty() {
        let commit = Commit<[Int]>()
        XCTAssert(commit.value.isEmpty)
        XCTAssert(commit.snapshot.isEmpty)
    }
}

#endif
