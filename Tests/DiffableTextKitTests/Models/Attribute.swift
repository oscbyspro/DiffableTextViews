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
// MARK: * Attribute x Tests
//*============================================================================*

final class AttributeTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let all: [Attribute] = [.virtual, .insertable, .removable, .passthrough]

    //=------------------------------------------------------------------------=
    // MARK: Tests x Instances
    //=------------------------------------------------------------------------=
    
    func testContentIsEmpty() {
        XCTAssert(Attribute.content.isEmpty)
        XCTAssertEqual(Attribute.content,[])
    }
    
    func testPhantomIsFull() {
        XCTAssertEqual(Attribute.phantom, Attribute(all))
    }
    
    func testInstancesAreUnique() {
        XCTAssertEqual(Set(all.map(\.rawValue)).count, all.count)
    }
}

#endif
