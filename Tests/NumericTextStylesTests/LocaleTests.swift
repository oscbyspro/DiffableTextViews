//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-30.
//

import XCTest
import Foundation

// MARK: - LocaleTests

/// Successfult tests enables assumptions to be made about the output of Swift's format styles.
final class LocaleTests: XCTestCase {
    typealias Style = FloatingPointFormatStyle<Double>
    
    // MARK: Setup
    
    lazy var locales: [Locale] = Locale.availableIdentifiers.map(Locale.init)
    lazy var signs: [String: Int] = makeAllAvailableSigns()
    lazy var fractionSeparators: [String: Int] = makeAllAvailableFractionSeparators()
    
    // MARK: Tests: Signs
    
    func testLocalizedSignsAreAnnoying() {
        XCTAssertGreaterThanOrEqual(signs.keys.count, 12)
    }
    
    // MARK: Tests: Fraction Separators
    
    func testLocalizedFractionSeparatorsAreAnnoying() {
        XCTAssertGreaterThanOrEqual(fractionSeparators.count, 3)
    }
    
    func testFractionSeparatorsAreAllSingleCharacters() {
        XCTAssertTrue(fractionSeparators.keys.lazy.map(\.count).allSatisfy({ $0 == 1 }))
    }

    // MARK: Helpers
    
    func makeAllAvailableSigns() -> [String: Int] {
        var signs: [String: Int] = [:]
        let unlocalized: Style = .number
            .precision(.significantDigits(0))
            .sign(strategy: .always())
        
        for locale in locales {
            let style = unlocalized.locale(locale)
            
            var positive = (+1.0).formatted(style)
            positive.removeAll(where: \.isNumber)
            
            var negative = (-1.0).formatted(style)
            negative.removeAll(where: \.isNumber)
            
            signs[positive] = (signs[positive] ?? 0) + 1
            signs[negative] = (signs[negative] ?? 0) + 1
        }
        
        return signs
    }
    
    func makeAllAvailableFractionSeparators() -> [String: Int] {
        var fractionSeparators: [String: Int] = [:]
        let value: Double = 0
        let unlocalized: Style = .number
            .precision(.significantDigits(0))
            .decimalSeparator(strategy: .always)
        
        for locale in locales {
            let style = unlocalized.locale(locale)
            var formatted = value.formatted(style)
            formatted.removeAll(where: \.isNumber)
            fractionSeparators[formatted] = (fractionSeparators[formatted] ?? 0) + 1
        }
        
        return fractionSeparators
    }
}
