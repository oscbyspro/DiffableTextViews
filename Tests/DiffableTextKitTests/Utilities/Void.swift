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
// MARK: * Void x Tests
//*============================================================================*

final class _VoidTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsSimilarToVoid() {
        XCTAssertEqual(MemoryLayout<_Void>.size,      MemoryLayout<Void>.size)
        XCTAssertEqual(MemoryLayout<_Void>.stride,    MemoryLayout<Void>.stride)
        XCTAssertEqual(MemoryLayout<_Void>.alignment, MemoryLayout<Void>.alignment)
    }
}

#endif
