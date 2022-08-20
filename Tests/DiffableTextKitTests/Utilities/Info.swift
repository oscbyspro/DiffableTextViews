//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

import XCTest

//*============================================================================*
// MARK: * Info x Tests
//*============================================================================*

final class InfoTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func DEBUG() throws {
        #if !DEBUG
        throw XCTSkip()
        #endif
    }
    
    func RELEASE() throws {
        #if DEBUG
        throw XCTSkip()
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x DEBUG
    //=------------------------------------------------------------------------=
    
    func testHasSomeSizeInDEBUG() throws {
        try DEBUG()
        
        XCTAssertGreaterThan(MemoryLayout<Info>.size, 0)
        XCTAssertGreaterThan(MemoryLayout<Brrr>.size, 0)
    }
    
    func testIsTransparentInDEBUG() throws {
        try DEBUG()
        
        XCTAssertEqual(   Info("Secret"), Info("Secret"))
        XCTAssertNotEqual(Info("Secret"), Info("xxxxxx"))
        
        XCTAssertEqual(   Brrr("Secret"), Brrr("Secret"))
        XCTAssertNotEqual(Brrr("Secret"), Brrr("xxxxxx"))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x RELEASE
    //=------------------------------------------------------------------------=
    
    func testHasZeroSizeInRELEASE() throws {
        try RELEASE()
        
        XCTAssertEqual(MemoryLayout<Info>.size, 0)
        XCTAssertEqual(MemoryLayout<Brrr>.size, 0)
    }
    
    func testIsOpaqueInRELEASE() throws {
        try RELEASE()
        
        XCTAssertEqual(Info("Secret"), Info("ABC"))
        XCTAssertEqual(Info("Secret"), Info("XYZ"))
        
        XCTAssertEqual(Brrr("Secret"), Brrr("ABC"))
        XCTAssertEqual(Brrr("Secret"), Brrr("XYZ"))
    }
}
