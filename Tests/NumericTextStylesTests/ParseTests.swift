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
    typealias Subject = Digits
    typealias Parser = DigitsParser
    
    // MARK: Setup
    
    let valid:    String = "12345"
    let invalidL: String = ".1234"
    let invalidM: String = "12.34"
    let invalidT: String = "1234."
        
    // MARK: Helpers

    func make(_ characters: String) -> Subject? {
        .init(characters: characters, parser: Parser.standard)
    }
    
    // MARK: Tests
    
    func test_initialization() {
        XCTAssertNotNil(make(valid))
        XCTAssertNil(make(invalidL))
        XCTAssertNil(make(invalidM))
        XCTAssertNil(make(invalidT))
    }
}

// MARK: - ParseTestsOfSeparator

final class ParseTestsOfSeparator: XCTestCase {
    typealias Subject = Separator
    typealias Parser = SeparatorParser
    
    // MARK: Setup
    
    let dot   = "."
    let comma = ","
    let dash  = "-"
    
    let parser:   Parser = .standard
    let parserSE: Parser = .standard.locale(Locale(identifier: "sv_SE"))
    let parserUS: Parser = .standard.locale(Locale(identifier: "en_US"))

    // MARK: Helpers
    
    func components(_ characters: String) -> Components {
        Components(
            normal:  Subject(characters: characters, parser: parser),
            swedish: Subject(characters: characters, parser: parserSE),
            english: Subject(characters: characters, parser: parserUS))
    }
    
    // MARK: Tests
    
    func test_initialization() {
        components(dot).expectation {
            Components(
                normal:  Subject(characters: dot),
                swedish: Subject(characters: dot),
                english: Subject(characters: dot))
        }
        
        components(comma).expectation {
            Components(
                normal:  nil,
                swedish: Subject(characters: dot),
                english: nil)
        }
        
        components(dash).expectation {
            Components(
                normal:  nil,
                swedish: nil,
                english: nil)
        }
    }
    
    // MARK: Components
    
    struct Components {
        let normal:  Subject?
        let swedish: Subject?
        let english: Subject?
        
        func expectation(_ expectation: () -> Self) {
            let expectation = expectation()
            
            XCTAssertEqual(normal?.characters,  expectation.normal?.characters)
            XCTAssertEqual(swedish?.characters, expectation.swedish?.characters)
            XCTAssertEqual(english?.characters, expectation.english?.characters)
        }
    }
}

// MARK: - ParseTestsOfSeparator

final class ParseTestsOfSign: XCTestCase {
    typealias Subject = Sign
    typealias Parser = SignParser
    
    // MARK: Setup
    
    let plus = "+"
    let minus = "-"
    let none = ""
    let invalid = "x"
        
    // MARK: Helpers
    
    func components(_ characters: String) -> Components {
        Components(standard: Subject(characters: characters, parser: Parser.standard))
    }
    
    // MARK: Tests
    
    func test_initialization() {
        components(plus).expectation {
            Components(standard: nil)
        }
        
        components(minus).expectation {
            Components(standard: Subject.negative)
        }

        components(none).expectation {
            Components(standard: Subject.none)
        }

        components(invalid).expectation {
            Components(standard: nil)
        }
    }
    
    // MARK: Components
    
    struct Components {
        let standard: Subject?
        
        func expectation(_ expectation: () -> Self) {
            let expectation = expectation()
            
            XCTAssertEqual(standard?.characters, expectation.standard?.characters)
        }
    }
}
