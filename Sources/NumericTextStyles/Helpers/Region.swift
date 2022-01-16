//
//  Region.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import Foundation
import DiffableTextViews

//*============================================================================*
// MARK: * Region
//*============================================================================*

@usableFromInline final class Region {
    @usableFromInline static let cache = NSCache<NSString, Region>()
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let formatter: NumberFormatter
        
    //=------------------------------------------------------------------------=
    // MARK: Properties - Characters
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var signs = Lexicon<Sign>()
    @usableFromInline private(set) var digits = Lexicon<Digit>()
    @usableFromInline private(set) var separators = Lexicon<Separator>()

    //=------------------------------------------------------------------------=
    // MARK: Properties - Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var locale: Locale {
        formatter.locale
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ locale: Locale) {
        //=--------------------------------------=
        // MARK: Formatter
        //=--------------------------------------=
        self.formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        //=--------------------------------------=
        // MARK: Signs
        //=--------------------------------------=
        self.signs = Lexicon<Sign>()
        signs[Sign.positive.character] = .positive
        signs[Sign.negative.character] = .negative
        signs.link(formatter .plusSign.filter({ $0.isPunctuation || $0.isMathSymbol }).first!, .positive)
        signs.link(formatter.minusSign.filter({ $0.isPunctuation || $0.isMathSymbol }).first!, .negative)
        //=--------------------------------------=
        // MARK: Digits
        //=--------------------------------------=
        self.digits = Lexicon<Digit>()
        for digit in Digit.allCases {
            digits[digit.character] = digit
            digits.link(formatter.string(from: digit.uInt8 as NSNumber)!.first!, digit)
        }
        //=--------------------------------------=
        // MARK: Characters - Separators
        //=--------------------------------------=
        self.separators = Lexicon<Separator>()
        separators[Separator.fraction.character] = .fraction
        separators[Separator.grouping.character] = .grouping
        separators.link(formatter .decimalSeparator.first!, .fraction)
        separators.link(formatter.groupingSeparator.first!, .grouping)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func reusable(_ locale: Locale) -> Region {
        let key = NSString(string: locale.identifier)
        if let reusable = cache.object(forKey: key) {
            return reusable
        } else {
            let instance = Region(locale)
            cache.setObject(instance,  forKey: key)
            return instance
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Number To Characters
    //=------------------------------------------------------------------------=
    
    @inlinable func characters(in number: Number) -> String {
        var characters = String()
        //=--------------------------------------=
        // MARK: Sign
        //=--------------------------------------=
        signs[number.sign]!.write(to: &characters)
        //=--------------------------------------=
        // MARK: Integer Digits
        //=--------------------------------------=
        for digit in number.integer.digits {
            digits[digit]!.write(to: &characters)
        }
        //=--------------------------------------=
        // MARK: Fraction Separator
        //=--------------------------------------=
        if let separator = number.separator {
            separators[separator]!.write(to: &characters)
            //=----------------------------------=
            // MARK: Fraction Digits
            //=----------------------------------=
            for digit in number.fraction.digits {
                digits[digit]!.write(to: &characters)
            }
        }
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return characters
    }
    
    //*========================================================================*
    // MARK: * Lexicon
    //*========================================================================*
    
    @usableFromInline struct Lexicon<Value: Hashable> {
        
        //=--------------------------------------------------------------------=
        // MARK: Properties
        //=--------------------------------------------------------------------=
        
        @usableFromInline var system: [Character: Value] = [:]
        @usableFromInline var region: [Value: Character] = [:]
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init() { }
        
        //=--------------------------------------------------------------------=
        // MARK: Subscripts
        //=--------------------------------------------------------------------=
        
        @inlinable subscript(key: Character) -> Value? {
            _read   { yield  system[key] }
            _modify { yield &system[key] }
        }
        
        @inlinable subscript(key: Value) -> Character? {
            _read   { yield  region[key] }
            _modify { yield &region[key] }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=

        @inlinable mutating func link(_ character: Character, _ value: Value) {
            system[character] = value
            region[value] = character
        }
        
        @inlinable mutating func link(_ value: Value, _ character: Character) {
            system[character] = value
            region[value] = character
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable func contains(_ key: Character) -> Bool {
            self[key] != nil
        }
        
        @inlinable func contains(_ key: Value) -> Bool {
            self[key] != nil
        }
    }
}
