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
    // MARK: Tests x State
    //=------------------------------------------------------------------------=
    
    func testSelectionIsNilByDefault() {
        XCTAssertEqual(Commit<Int>(3, "3").selection, nil)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInitOptionalWithoutArgumentsIsNilAndEmpty() {
        let commit = Commit<Int?>()
        XCTAssertNil(commit.value)
        XCTAssert(commit.snapshot.isEmpty)
    }
    
    func testInitOptionalIsWithNonoptionalArgumentEqualsArgument() {
        let nonoptional = Commit<Int>(3, "3")
        let optional = Commit<Optional<Int>>(nonoptional)
        XCTAssertEqual(optional.value, nonoptional.value)
        XCTAssertEqual(optional.snapshot, nonoptional.snapshot)
    }

    func testInitRangeReplaceableCollectionWithoutArgumentsIsEmpty() {
        let commit = Commit<[Int]>()
        XCTAssert(commit.value.isEmpty)
        XCTAssert(commit.snapshot.isEmpty)
    }
}

#endif
