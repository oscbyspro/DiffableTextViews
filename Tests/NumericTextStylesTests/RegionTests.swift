//
//  RegionTests.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

#if DEBUG

import Foundation
import XCTest

@testable import NumericTextStyles

//*============================================================================*
// MARK: * RegionTests
//*============================================================================*

final class RegionTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var regions = Locale
        .availableIdentifiers
        .lazy
        .map(Locale.init)
        .map(Region.init)
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSigns() {
        let positive: Int = +1
        let negative: Int = -1
        
        for region in regions {
            let style = IntegerFormatStyle<Int>
                .number
                .locale(region.locale)
                .sign(strategy: .always())
            
            let positives = positive.formatted(style)
            XCTAssertNotNil(positives.first(where: region.signs.keys.contains))

            let negatives = negative.formatted(style)
            XCTAssertNotNil(negatives.first(where: region.signs.keys.contains))
        }
    }
    
    func testDigits() {
        let number: Int = 1234567890
        
        for region in regions {
            let style = IntegerFormatStyle<Int>
                .number
                .locale(region.locale)
                .grouping(.never)
            
            let numbers = number.formatted(style)
            XCTAssert(numbers.allSatisfy(region.digits.keys.contains))
        }
    }
    
    func testGroupingSeparators() {
        let number: Int = 1234567890
        
        for region in regions {
            let style = IntegerFormatStyle<Int>
                .number
                .locale(region.locale)
            
            let nonnumbers = number.formatted(style).filter({ !$0.isNumber })
            XCTAssertNotNil(nonnumbers.allSatisfy({ region.separators[$0] == .grouping }))
        }
    }
    
    func testFractionSeparators() {
        let number: Double = 0.123
        
        for region in regions {
            let style = FloatingPointFormatStyle<Double>
                .number
                .locale(region.locale)
            
            let nonnumbers = number.formatted(style).filter({ !$0.isNumber })
            XCTAssertNotNil(nonnumbers.allSatisfy({ region.separators[$0] == .fraction }))
        }
    }
}

#endif
