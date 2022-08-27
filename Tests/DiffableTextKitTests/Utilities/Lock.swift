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
// MARK: * Lock x Tests
//*============================================================================*

@MainActor final class LockTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    var lock = Lock()
    
    //=------------------------------------------------------------------------=
    // MARK: State x Setup
    //=------------------------------------------------------------------------=
    
    override func setUp() {
        lock = Lock()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x State
    //=------------------------------------------------------------------------=
    
    func testIsNotLockedByDefault() {
        XCTAssertFalse(lock.isLocked)
    }
    
    func testIsLockedIsSameAsCountIsZero() {
        XCTAssertFalse(lock.isLocked)
        XCTAssertEqual(lock.count, 0)
        
        lock.lock()
        XCTAssert(lock.isLocked)
        XCTAssertEqual(lock.count, 1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations
    //=------------------------------------------------------------------------=
    
    func testLockIncrementsCountOpenDecrementsCount() {
        XCTAssertEqual(lock.count, 0)

        lock.lock()
        lock.lock()
        lock.lock()

        XCTAssertEqual(lock.count, 3)
        
        lock.open()
        lock.open()
        lock.open()

        XCTAssertEqual(lock.count, 0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Utilities
    //=------------------------------------------------------------------------=
    
    func testSynchronousActionLocksUntilCompletion() {
        XCTAssertFalse(lock.isLocked)
        //=--------------------------------------=
        // Start
        //=--------------------------------------=
        lock.perform {
            XCTAssert(self.lock.isLocked)
        }
        //=--------------------------------------=
        // End
        //=--------------------------------------=
        XCTAssertFalse(lock.isLocked)
    }
    
    func testAsynchronousOperationLocksUntilCompletion() async {
        XCTAssertFalse(lock.isLocked)
        //=--------------------------------------=
        // Start
        //=--------------------------------------=
        let task = lock.asynchronous {
            XCTAssert(self.lock.isLocked) // 2nd
        };  XCTAssert(self.lock.isLocked) // 1st
        
        await task.value
        //=--------------------------------------=
        // End
        //=--------------------------------------=
        XCTAssertFalse(lock.isLocked)
    }
}

#endif
