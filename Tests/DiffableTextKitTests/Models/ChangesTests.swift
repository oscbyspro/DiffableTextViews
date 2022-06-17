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
// MARK: * Changes x Tests
//*============================================================================*

final class ChangesTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let all: [Changes] = [.style, .value, .focus]

    //=------------------------------------------------------------------------=
    // MARK: Tests x Instances
    //=------------------------------------------------------------------------=
    
    func testRawValuesAreUnique() {
        XCTAssertEqual(Set(all.map(\.rawValue)).count, all.count)
    }
}

#endif
