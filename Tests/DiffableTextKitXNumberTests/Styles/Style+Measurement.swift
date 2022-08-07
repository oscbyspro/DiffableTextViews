//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import DiffableTextKitXNumber

import XCTest

#warning("WIP")
#warning("WIP")
#warning("WIP")

//*============================================================================*
// MARK: * Style x Tests x Measurement
//*============================================================================*

final class StyleTestsOnMeasurement: StyleTests {
    
    typealias Style<Unit: Dimension> = NumberTextStyle<Double>.Measurement<Unit>
    typealias Width<Unit: Dimension> = Measurement<Unit>.FormatStyle.UnitWidth
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    #warning("...........................................")
    func XCTAssertSuccess<Unit: Dimension>(_ units: [Unit]) {
        let widths: [Width<Unit>] = [.narrow, .abbreviated, .wide]
        //=--------------------------------------=
        // Locale x Unit x Width
        //=--------------------------------------=
        for locale in locales {
            for unit in units {
                for width in widths {
                    XCTAssert(123456.789, with: Style<Unit>(unit: unit, width: width, locale: locale))
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    #warning("FIXME")
    /// - Iterations: 5,670
    func testAcceleration() {
        XCTAssertSuccess(Units.acceleration)
    }
    
    /// - Iterations: 39,690
    func testArea() {
        XCTAssertSuccess(Units.areas)
    }
    
    #warning("FIXME")
    /// - Iterations: 17,010
    func testAngle() {
        XCTAssertSuccess(Units.angles)
    }
    
    /// - Iterations: 5,670
    func testConcentrationMass() {
        XCTAssertSuccess(Units.concentrationMass)
    }
    
    /// - Iterations: 19,845
    func testDuration() {
        XCTAssertSuccess(Units.duration)
    }
    
    /// - Iterations: 2,835
    func testDispersion() {
        XCTAssertSuccess(Units.dispersion)
    }
    
    #warning("FIXME")
    /// - Iterations: 14,175
    func testEnergy() {
        XCTAssertSuccess(Units.energy)
    }
    
    /// - Iterations: 17,010
    func testElectricCharge() {
        XCTAssertSuccess(Units.electricCharge)
    }
    
    /// - Iterations: 14,175
    func testElectricCurrent() {
        XCTAssertSuccess(Units.electricCurrent)
    }
    
    /// - Iterations: 14,175
    func testElectricResistance() {
        XCTAssertSuccess(Units.electricResistance)
    }
    
    #warning("FIXME")
    /// - Iterations: 14,175
    func testElectricPotentialDifference() {
        XCTAssertSuccess(Units.electricPotentialDifference)
    }
    
    /// - Iterations: 25,515
    func testFrequency() {
        XCTAssertSuccess(Units.frequency)
    }
    
    #warning("FIXME")
    /// - Iterations:
    func testFuelEfficiency() {
        XCTAssertSuccess(Units.fuelEfficiency)
    }

    /// - Iterations: 2,835
    func testIlluminance() {
        XCTAssertSuccess(Units.illuminance)
    }
    
    #warning("FIXME")
    /// - Iterations: 99,225
    func testInformationStorage() {
        XCTAssertSuccess(Units.informationStorage)
    }
    
    #warning("FIXME")
    /// - Iterations: 62,370
    func testLength() {
        XCTAssertSuccess(Units.length)
    }
    
    /// - Iterations: 45,360
    func testMass() {
        XCTAssertSuccess(Units.mass)
    }
    
    #warning("FIXME")
    /// - Iterations: 31,185
    func testPower() {
        XCTAssertSuccess(Units.power)
    }

    #warning("FIXME")
    /// - Iterations: 28,350
    func testPressure() {
        XCTAssertSuccess(Units.pressure)
    }
    
    /// - Iterations: 11,340
    func testSpeed() {
        XCTAssertSuccess(Units.speed)
    }
    
    /// - Iterations: 8,505
    func testTemperature() {
        XCTAssertSuccess(Units.temperature)
    }
    
    #warning("FIXME")
    /// - Iterations: 87,885
    func testVolume() {
        XCTAssertSuccess(Units.volume)
    }
}

#endif
