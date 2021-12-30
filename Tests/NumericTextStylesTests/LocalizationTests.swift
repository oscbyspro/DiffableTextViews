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
    lazy var availableSignSets: [String: Int] = makeAllAvailableSignSets()
    lazy var availableDigitSets: [String: Int] = makeAllAvailableDigitSets()
    lazy var availableFractionSeparators: [String: Int] = makeAllAvailableFractionSeparators()

    // MARK: Tests: Locale
    
    func testThereAreManyManyManyLocalesOutThere() {
        XCTAssertGreaterThanOrEqual(availableLocales.count, 937)
    }
    
    // MARK: Tests: Signs
    
    func testCantHardcodeSigns() {
        print(availableSignSets.count)
        XCTAssertGreaterThanOrEqual(availableSignSets.keys.count, 7)
    }
        
    // MARK: Tests: Fraction Separators
    
    func testCantHardcodeFractionSeparators() {
        XCTAssertGreaterThanOrEqual(availableFractionSeparators.count, 3)
    }
    
    func testFractionSeparatorsAreAllSingleCharacters() {
        XCTAssertTrue(availableFractionSeparators.keys.lazy.map(\.count).allSatisfy({ $0 == 1 }))
    }
    
    // MARK: Tests: Digits
    
    func testCantHardcodeDigits() {
        XCTAssertGreaterThanOrEqual(availableDigitSets.count, 11)
    }
    
    // MARK: Helpers
    
    func makeAllAvailableSignSets() -> [String: Int] {
        var signs: [String: Int] = [:]
        let unlocalized: Style = .number
        
        for locale in availableLocales {
            let style: Style = unlocalized.locale(locale)
            
            var positive: String = (+1.0).formatted(style)
            positive.removeAll(where: \.isNumber)
            
            var negative: String = (-1.0).formatted(style)
            negative.removeAll(where: \.isNumber)
            
            let pair = positive + negative
            
            signs[pair] = (signs[pair] ?? 0) + 1
        }
        
        return signs
    }
    
    func makeAllAvailableFractionSeparators() -> [String: Int] {
        var fractionSeparators: [String: Int] = [:]
        let value: Double = 0
        let unlocalized: Style = .number
            .precision(.significantDigits(0))
            .decimalSeparator(strategy: .always)
        
        for locale in availableLocales {
            let style: Style = unlocalized.locale(locale)
            var formatted: String = value.formatted(style)
            formatted.removeAll(where: \.isNumber)
            fractionSeparators[formatted] = (fractionSeparators[formatted] ?? 0) + 1
        }
        
        return fractionSeparators
    }
    
    func makeAllAvailableDigitSets() -> [String: Int] {
        var digits: [String: Int] = [:]
        let value: Double = 123456789
        let unlocalized: Style = .number.grouping(.never)
        
        for locale in availableLocales {
            let style: Style = unlocalized.locale(locale)
            let formatted: String = value.formatted(style)
            digits[formatted] = (digits[formatted] ?? 0) + 1
        }
        
        return digits
    }
}
