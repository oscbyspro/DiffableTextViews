//
//  ParseTests.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import XCTest
@testable import NumericTextStyles

// MARK: - ParseTestsOfDigits

final class ParseTestsOfDigits: XCTestCase {
    
    // MARK: Setup
    
    let valid:    String = "12345"
    let invalidL: String = ".1234"
    let invalidM: String = "12.34"
    let invalidT: String = "1234."
    
    let parser: _Digits.Parser = .decimals
    
    // MARK: Helpers

    func make(_ characters: String) -> _Digits? {
        .init(characters: characters, parser: parser)
    }
    
    // MARK: Tests
    
    func test() {
        XCTAssertNotNil(make(valid))
        XCTAssertNil(make(invalidL))
        XCTAssertNil(make(invalidM))
        XCTAssertNil(make(invalidT))
    }
}
