//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Constants x Units [...]
//*============================================================================*

enum Units {
    
    static let acceleration: [UnitAcceleration] = [
        .gravity,
        .metersPerSecondSquared,
    ]
    
    static let areas: [UnitArea] = [
        .acres,
        .ares,
        .hectares,
        .squareMegameters,
        .squareKilometers,
        .squareMeters,
        .squareCentimeters,
        .squareMillimeters,
        .squareMicrometers,
        .squareNanometers,
        .squareInches,
        .squareFeet,
        .squareYards,
        .squareMiles,
    ]
    
    static let angles: [UnitAngle] = [
        .arcMinutes,
        .arcSeconds,
        .degrees,
        .gradians,
        .radians,
        .revolutions,
    ]
    
    static let concentrationMass: [UnitConcentrationMass] = [
        .gramsPerLiter,
        .milligramsPerDeciliter,
    ]
    
    static let duration: [UnitDuration] = [
        .hours,
        .minutes,
        .seconds,
        .milliseconds,
        .microseconds,
        .nanoseconds,
        .picoseconds,
    ]
    
    static let dispersion: [UnitDispersion] = [
        .partsPerMillion,
    ]
    
    static let energy: [UnitEnergy] = [
        .kilojoules,
        .joules,
        .kilocalories,
        .calories,
        .kilowattHours,
    ]
    
    static let electricCharge: [UnitElectricCharge] = [
        .coulombs,
        .megaampereHours,
        .kiloampereHours,
        .ampereHours,
        .milliampereHours,
        .microampereHours,
    ]
    
    static let electricCurrent: [UnitElectricCurrent] = [
        .megaamperes,
        .kiloamperes,
        .amperes,
        .milliamperes,
        .microamperes,
    ]
    
    static let electricResistance: [UnitElectricResistance] = [
        .megaohms,
        .kiloohms,
        .ohms,
        .milliohms,
        .microohms,
    ]
    
    static let electricPotentialDifference: [UnitElectricPotentialDifference] = [
        .megavolts,
        .kilovolts,
        .volts,
        .millivolts,
        .microvolts,
    ]
    
    static let frequency: [UnitFrequency] = [
        .terahertz,
        .gigahertz,
        .megahertz,
        .kilohertz,
        .hertz,
        .millihertz,
        .microhertz,
        .nanohertz,
        .framesPerSecond,
    ]
    
    static let fuelEfficiency: [UnitFuelEfficiency] = [
        .litersPer100Kilometers,
        .milesPerImperialGallon,
        .milesPerGallon,
    ]

    static let illuminance: [UnitIlluminance] = [
        .lux,
    ]

    static let informationStorage: [UnitInformationStorage] = [
        .bytes,
        .bits,
        .nibbles,
        .yottabytes,
        .zettabytes,
        .exabytes,
        .petabytes,
        .terabytes,
        .gigabytes,
        .megabytes,
        .kilobytes,
        .yottabits,
        .zettabits,
        .exabits,
        .petabits,
        .terabits,
        .gigabits,
        .megabits,
        .kilobits,
        .yobibytes,
        .zebibytes,
        .exbibytes,
        .pebibytes,
        .tebibytes,
        .gibibytes,
        .mebibytes,
        .kibibytes,
        .yobibits,
        .zebibits,
        .exbibits,
        .pebibits,
        .tebibits,
        .gibibits,
        .mebibits,
        .kibibits,
    ]

    static let length: [UnitLength] = [
        .megameters,
        .kilometers,
        .hectometers,
        .decameters,
        .meters,
        .decimeters,
        .centimeters,
        .millimeters,
        .micrometers,
        .nanometers,
        .picometers,
        .inches,
        .feet,
        .yards,
        .miles,
        .scandinavianMiles,
        .lightyears,
        .nauticalMiles,
        .fathoms,
        .furlongs,
        .astronomicalUnits,
        .parsecs,
    ]

    static let mass: [UnitMass] = [
        .kilograms,
        .grams,
        .decigrams,
        .centigrams,
        .milligrams,
        .micrograms,
        .nanograms,
        .picograms,
        .ounces,
        .pounds,
        .stones,
        .metricTons,
        .shortTons,
        .carats,
        .ouncesTroy,
        .slugs,
    ]

    static let power: [UnitPower] = [
        .terawatts,
        .gigawatts,
        .megawatts,
        .kilowatts,
        .watts,
        .milliwatts,
        .microwatts,
        .nanowatts,
        .picowatts,
        .femtowatts,
        .horsepower,
    ]

    static let pressure: [UnitPressure] = [
        .newtonsPerMetersSquared,
        .gigapascals,
        .megapascals,
        .kilopascals,
        .hectopascals,
        .inchesOfMercury,
        .bars,
        .millibars,
        .millimetersOfMercury,
        .poundsForcePerSquareInch,
    ]
    
    static let speed: [UnitSpeed] = [
        .metersPerSecond,
        .kilometersPerHour,
        .milesPerHour,
        .knots,
    ]

    static let temperature: [UnitTemperature] = [
        .kelvin,
        .celsius,
        .fahrenheit,
    ]

    static let volume: [UnitVolume] = [
        .megaliters,
        .kiloliters,
        .liters,
        .deciliters,
        .centiliters,
        .milliliters,
        .cubicKilometers,
        .cubicMeters,
        .cubicDecimeters,
        .cubicCentimeters,
        .cubicMillimeters,
        .cubicInches,
        .cubicFeet,
        .cubicYards,
        .cubicMiles,
        .acreFeet,
        .bushels,
        .teaspoons,
        .tablespoons,
        .fluidOunces,
        .cups,
        .pints,
        .quarts,
        .gallons,
        .imperialTeaspoons,
        .imperialTablespoons,
        .imperialFluidOunces,
        .imperialPints,
        .imperialQuarts,
        .imperialGallons,
        .metricCups,
    ]
}
