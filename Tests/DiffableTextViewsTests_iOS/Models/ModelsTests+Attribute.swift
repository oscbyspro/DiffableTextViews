//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import Support
import XCTest
import XCTestSupport

@testable import DiffableTextViews

//*============================================================================*
// MARK: * ModelsTests x Attribute
//*============================================================================*

final class ModelsTests_Attribute: Tests {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let attributes: [Attribute] = [.virtual, .insertable, .removable, .passthrough]

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testContentIsEmpty() {
        XCTAssert(Attribute.content.isEmpty)
    }
    
    func testEachAttributeIsUnique() {
        for attribute in attributes {
            XCTAssertEqual(attributes.count(where: { $0 == attribute }), 1)
        }
    }
}

#endif
