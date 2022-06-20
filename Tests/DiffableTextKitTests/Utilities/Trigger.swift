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
// MARK: * Trigger x Tests
//*============================================================================*

final class TriggerTests: XCTestCase {
    typealias T = Trigger
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Utilities
    //=------------------------------------------------------------------------=
    
    func testCallAsFunctionWithoutArgumentsCallsClosure() {
        var value = 0
        let trigger = T({ value += 1 })
        
        trigger()
        trigger()
        trigger()
        
        XCTAssertEqual(value, 3)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations
    //=------------------------------------------------------------------------=
    
    func testInoutPlusEqualsAppendsArgument() {
        var values = [Int]()
        var trigger = T({ })
        
        trigger += T({ values += [0] })
        trigger += T({ values += [1] })
        trigger += T({ values += [2] })
        
        trigger()

        XCTAssertEqual(values, [0, 1, 2])
    }
}

//*============================================================================*
// MARK: * Trigger x Optional x Tests
//*============================================================================*

final class OptionalTriggerTests: XCTestCase {
    typealias T = Optional<Trigger>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Utilities
    //=------------------------------------------------------------------------=
    
    func testCallAsFunctionWithoutArgumentsCallsClosure() {
        var value = 0
        let trigger = T({ value += 1 })
        
        trigger()
        trigger()
        trigger()
        
        XCTAssertEqual(value, 3)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations
    //=------------------------------------------------------------------------=
    
    func testInoutSomePlusEqualsSomeAppendsSome() {
        var values = [Int]()
        var trigger = T({ })
        
        trigger += T({ values += [0] })
        trigger += T({ values += [1] })
        trigger += T({ values += [2] })
        
        trigger()

        XCTAssertNotNil(trigger)
        XCTAssertEqual(values, [0, 1, 2])
    }
    
    func testInoutSomePlusEqualsNoneSetsNone() {
        var values = [Int]()
        var trigger = T({ })
        
        trigger += T({ values += [0] })
        trigger += T({ values += [1] })
        trigger += T({ values += [2] })
        trigger += nil
        
        trigger()
        
        XCTAssertNil(trigger)
        XCTAssertEqual(values, [])
    }
    
    func testInoutNonePlusEqualsSomeSetsSome() {
        var values = [Int]()
        var trigger = T.none
        
        trigger += T({ values += [0] })
        trigger += T({ values += [1] })
        trigger += T({ values += [2] })
        
        trigger()
        
        XCTAssertNotNil(trigger)
        XCTAssertEqual(values, [0, 1, 2])
    }
}

#endif
