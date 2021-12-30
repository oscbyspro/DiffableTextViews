//
//  LocalizationTests.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-30.
//

import XCTest
import Foundation

// MARK: - LocalizationTests

/// Guarantees some assumptions about number format styles.
///
/// ```
/// Asserts: Hardcoding character values is NOT feasible.
/// ```
///
/// ```
/// Asserts: Digits are numbers and non-digits are NOT numbers.
/// ```
///
/// ```
/// Asserts: Digits are always 1 character in size.
/// Asserts: Fraction separators are always 1 character in size.
/// Asserts: Grouping separators are always 1 character in size.
/// Asserts: Signs are NOT always 1 character in size (!).
/// ```
/// ```
/// Asserts: Grouping separators are NOT always used.
/// ```
///
final class LocalizationTests: XCTestCase {
    typealias Style = FloatingPointFormatStyle<Double>
    
    // MARK: Setup
    
    lazy var locales: [Locale] = Locale.availableIdentifiers.map(Locale.init)
    lazy var digitsSets: Set<Set<String>> = makeAvailableDigitsSets()
    lazy var fractionSeparators: Set<String> = makeAvailableFractionSeparators()
    lazy var groupingSeparators: Set<String> = makeAvailableGroupingSeparators()
    lazy var signsSets: Set<Set<String>> = makeAvailableSignSets()

    // MARK: Tests: Is Hardcodable

    func testThereAreManyLocales() {
        XCTAssertGreaterThanOrEqual(locales.count, 937)
    }

    func testCantHardcodeDigits() {
        XCTAssertGreaterThanOrEqual(digitsSets.count, 11)
    }

    func testCantHardcodeFractionSeparators() {
        XCTAssertGreaterThanOrEqual(fractionSeparators.count, 3)
    }

    func testCantHardcodeGroupingSeparators() {
        XCTAssertGreaterThanOrEqual(groupingSeparators.count, 9)
    }

    func testCantHardcodeSigns() {
        XCTAssertGreaterThanOrEqual(signsSets.count, 7)
    }

    // MARK: Tests: Is Number

    func testDigitsAreNumbers() {
        for digits in digitsSets {
            for digit in digits {
                XCTAssertEqual(digit.lazy.filter(\.isNumber).count, digit.count)
            }
        }
    }

    func testFractionSeparatorsAreNotNumbers() {
        for separator in fractionSeparators {
            XCTAssertTrue(separator.lazy.filter(\.isNumber).isEmpty)
        }
    }

    func testGroupingSeparatorsAreNotNumbers() {
        for separator in groupingSeparators {
            XCTAssertTrue(separator.lazy.filter(\.isNumber).isEmpty)
        }
    }

    func testSignsAreNotNumbers() {
        for signs in signsSets {
            for sign in signs {
                XCTAssertTrue(sign.lazy.filter(\.isNumber).isEmpty)
            }
        }
    }
    
    // MARK: Tests: Size
    
    func testDigitsAreAlwaysOneCharacterInSize() {
        for digits in digitsSets {
            for digit in digits {
                XCTAssertEqual(digit.count, 1)
            }
        }
    }
    
    func testFractionSeparatorsAreAlwaysOneCharacterInSize() {
        for separator in fractionSeparators {
            XCTAssertEqual(separator.count, 1)
        }
    }
    
    func testGroupingSeparatorsAreAlwaysOneCharacterInSize() {
        for separator in groupingSeparators {
            XCTAssertEqual(separator.count, 1)
        }
    }
    
    func testSignsCanBeMoreThanOneCharacterInSize() {
        for signs in signsSets {
            for sign in signs {
                if sign.count > 1 { return }
            }
        }
        
        XCTFail()
    }
    
    // MARK: Tests: Usage
    
    func testGroupingSeparatorsAreNotAlwaysUsed() {
        let locale = Locale(identifier: "us_POSIX")
        let style: Style = .number.locale(locale)
        let number: Double = 1234567890
        let result = number.formatted(style)
        XCTAssertTrue(result.allSatisfy(\.isNumber))
    }
    
    // MARK: Helpers
    
    func makeAvailableDigitsSets() -> Set<Set<String>> {
        var result: Set<Set<String>> = []
        let values: [Double] = "1234567890".map({ Double(String($0))! })
        let unlocalized: Style = .number.grouping(.never)
        
        for locale in locales {
            let style: Style = unlocalized.locale(locale)
            var digits: Set<String> = []
            
            for value in values {
                let digit: String = value.formatted(style)
                digits.insert(digit)
            }
            
            result.insert(digits)
        }
        
        return result
    }
    
    func makeAvailableFractionSeparators() -> Set<String> {
        var result: Set<String> = []
        let value: Double = 0
        let unlocalized: Style = .number.decimalSeparator(strategy: .always)

        for locale in locales {
            let style: Style = unlocalized.locale(locale)
            var separator: String = value.formatted(style)
            separator.removeAll(where: \.isNumber)
            result.insert(separator)
        }

        return result
    }

    func makeAvailableGroupingSeparators() -> Set<String> {
        var result: Set<String> = []
        let value: Double = 1234567890
        let unlocalized: Style = .number.grouping(.automatic)

        for locale in locales {
            let style: Style = unlocalized.locale(locale)
            let formatted: String = value.formatted(style)
            
            if  let start = formatted.firstIndex(where: { !$0.isNumber }),
                let end = formatted[formatted.index(after: start)...].firstIndex(where: \.isNumber) {
                let separator = String(formatted[start ..< end])
                result.insert(separator)
            }
        }

        return result
    }

    func makeAvailableSignSets() -> Set<Set<String>> {
        var result: Set<Set<String>> = []
        let unlocalized: Style = .number.sign(strategy: .always())

        for locale in locales {
            let style: Style = unlocalized.locale(locale)
            var signs: Set<String> = []
            
            var positive: String = (+1.0).formatted(style)
            positive.removeAll(where: \.isNumber)
            signs.insert(positive)

            var negative: String = (-1.0).formatted(style)
            negative.removeAll(where: \.isNumber)
            signs.insert(negative)

            result.insert(signs)
        }

        return result
    }
}
