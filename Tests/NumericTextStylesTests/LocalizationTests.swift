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
/// ```Asserts: Hardcoding character values is a bad idea.```
///
/// ```Asserts: [digit, nondigit].map(\.isNumber) == [true, false]```
///
/// ```Asserts: [f-separator, g-separator].map(\.count) == [1...1, 0...1]```
///
final class LocalizationTests: XCTestCase {
    typealias Style = FloatingPointFormatStyle<Double>
    
    // MARK: Setup
    
    lazy var availableLocales: [Locale] = Locale.availableIdentifiers.map(Locale.init)
    lazy var availableDigitSets: [String: Int] = makeAllAvailableDigitSets()
    lazy var availableFractionSeparators: [String: Int] = makeAllAvailableFractionSeparators()
    lazy var availableGroupingSeparators: [String: Int] = makeAllAvailableGroupingSeparators()
    lazy var availableSignSets: [String: Int] = makeAllAvailableSignSets()

    // MARK: Tests: Is Hardcodable
    
    func testThereAreManyLocalesOutThere() {
        let locales = availableLocales
        XCTAssertGreaterThanOrEqual(locales.count, 937)
    }
    
    func testCantHardcodeDigits() {
        let digitSets = availableDigitSets.keys
        XCTAssertGreaterThanOrEqual(digitSets.count, 11)
    }
    
    func testCantHardcodeFractionSeparators() {
        let separators = availableFractionSeparators.keys
        XCTAssertGreaterThanOrEqual(separators.count, 3)
    }
    
    func testCantHardcodeGroupingSeparators() {
        let separators = availableGroupingSeparators.keys
        XCTAssertGreaterThanOrEqual(separators.count, 10)
    }
    
    func testCantHardcodeSigns() {
        let signSets = availableSignSets.keys
        XCTAssertGreaterThanOrEqual(signSets.count, 7)
    }

    // MARK: Tests: Character Is Number
    
    func testDigitsAreNumbers() {
        let digitSets = availableDigitSets.keys
        for digits in digitSets {
            XCTAssertEqual(digits.filter(\.isNumber).count, digits.count)
        }
    }
    
    func testFractionSeparatorsAreNotNumbers() {
        let separators = availableFractionSeparators.keys
        for separator in separators {
            XCTAssertTrue(separator.lazy.filter(\.isNumber).isEmpty)
        }
    }
    
    func testGroupingSeparatorsAreNotNumbers() {
        let separators = availableGroupingSeparators.keys
        for separator in separators {
            XCTAssertTrue(separator.lazy.filter(\.isNumber).isEmpty)
        }
    }
    
    func testSignsAreNotNumbers() {
        let signsSets = availableSignSets.keys
        for signs in signsSets {
            XCTAssertTrue(signs.lazy.filter(\.isNumber).isEmpty)
        }
    }
    
    // MARK: Tests: Separator Size.

    func testFractionSeparatorsAreAllSingleCharacters() {
        let separators = availableFractionSeparators.keys
        XCTAssertTrue(separators.lazy.map(\.count).allSatisfy({ $0 == 1 }))
    }
    
    func testGroupingSeparatorsAreAllOneOrZeroCharacters() {
        let separators = availableGroupingSeparators.keys
        XCTAssertTrue(separators.lazy.map(\.count).allSatisfy({ $0 <= 1 }))
    }
    
    // MARK: Helpers
    
    func makeAllAvailableDigitSets() -> [String: Int] {
        var result: [String: Int] = [:]
        let value: Double = 123456789
        let unlocalized: Style = .number.grouping(.never)
        
        for locale in availableLocales {
            let style: Style = unlocalized.locale(locale)
            let formatted: String = value.formatted(style)
            result[formatted] = (result[formatted] ?? 0) + 1
        }
        
        return result
    }
    
    func makeAllAvailableFractionSeparators() -> [String: Int] {
        var result: [String: Int] = [:]
        let value: Double = 0
        let unlocalized: Style = .number.decimalSeparator(strategy: .always)
        
        for locale in availableLocales {
            let style: Style = unlocalized.locale(locale)
            var formatted: String = value.formatted(style)
            formatted.removeAll(where: \.isNumber)
            result[formatted] = (result[formatted] ?? 0) + 1
        }
        
        return result
    }
    
    func makeAllAvailableGroupingSeparators() -> [String: Int] {
        var result: [String: Int] = [:]
        let value: Double = 123456789
        let unlocalized: Style = .number.grouping(.automatic)
        
        for locale in availableLocales {
            let style: Style = unlocalized.locale(locale)
            let formatted: String = value.formatted(style)
            var separator: String = ""
            
            if  let start = formatted.firstIndex(where: { !$0.isNumber }),
                let end = formatted[formatted.index(after: start)...].firstIndex(where: \.isNumber) {
                separator = String(formatted[start ..< end])
            }
            
            result[separator] = (result[separator] ?? 0) + 1
        }
        
        return result
    }
    
    func makeAllAvailableSignSets() -> [String: Int] {
        var result: [String: Int] = [:]
        let unlocalized: Style = .number.sign(strategy: .always())
        
        for locale in availableLocales {
            let style: Style = unlocalized.locale(locale)
            
            var positive: String = (+1.0).formatted(style)
            positive.removeAll(where: \.isNumber)
            
            var negative: String = (-1.0).formatted(style)
            negative.removeAll(where: \.isNumber)
            
            let signs = positive + negative
            
            result[signs] = (result[signs] ?? 0) + 1
        }
        
        return result
    }
}
