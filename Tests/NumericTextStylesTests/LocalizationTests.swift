//
//  LocalizationTests.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-30.
//

import XCTest
import Foundation

// MARK: - LocalizationTests

final class LocalizationTests: XCTestCase {
    typealias Style = FloatingPointFormatStyle<Double>
    
    // MARK: Setup
    
    lazy var availableLocales: [Locale] = Locale.availableIdentifiers.map(Locale.init)
    lazy var availableDigitSets: [String: Int] = makeAllAvailableDigitSets()
    lazy var availableFractionSeparators: [String: Int] = makeAllAvailableFractionSeparators()
    lazy var availableGroupingSeparators: [String: Int] = makeAllAvailableGroupingSeparators()
    lazy var availableSignSets: [String: Int] = makeAllAvailableSignSets()

    // MARK: Tests: Locale
    
    func testThereAreManyManyManyLocalesOutThere() {
        XCTAssertGreaterThanOrEqual(availableLocales.count, 937)
    }
    
    
    // MARK: Tests: Digits
    
    func testCantHardcodeDigits() {
        XCTAssertGreaterThanOrEqual(availableDigitSets.count, 11)
    }
    
    // MARK: Tests: Fraction Separators
    
    func testCantHardcodeFractionSeparators() {
        XCTAssertGreaterThanOrEqual(availableFractionSeparators.count, 3)
    }
    
    func testFractionSeparatorsAreAllSingleCharacters() {
        XCTAssertTrue(availableFractionSeparators.keys.lazy.map(\.count).allSatisfy({ $0 == 1 }))
    }
    
    // MARK: Tests: Grouping Separators
    
    func testCantHardcodeGroupingSeparators() {
        XCTAssertGreaterThanOrEqual(availableGroupingSeparators.count, 12)
    }
    
    func testGroupingSeparatorsAreAllSingleCharacters() {
        XCTAssertTrue(availableFractionSeparators.keys.lazy.map(\.count).allSatisfy({ $0 == 1 }))
    }
    
    // MARK: Tests: Signs
    
    func testCantHardcodeSigns() {
        print(availableSignSets.count)
        XCTAssertGreaterThanOrEqual(availableSignSets.keys.count, 7)
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
            var formatted: String = value.formatted(style)
            formatted.removeAll(where: \.isNumber)
            result[formatted] = (result[formatted] ?? 0) + 1
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
