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
// MARK: * Graph x Tests x Floats
//*============================================================================*

final class GraphTestsOnFloats: XCTestCase {
    typealias Float = _Input & BinaryFloatingPoint
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let floats: [any Float.Type] = [Double.self]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bounds
    //=------------------------------------------------------------------------=
    
    func testMaxIsLessThanOrEqualToDouble() {
        for float in floats {
            XCTAssertLessThanOrEqual(Double(float.max), Double.max)
        }
    }
    
    func testPrecisionIsLessThanOrEqualToDouble() {
        for float in floats {
            XCTAssertLessThanOrEqual(float.precision, Double.precision)
        }
    }
}

#endif

