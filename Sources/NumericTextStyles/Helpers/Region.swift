//
//  Region.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import Foundation

//*============================================================================*
// MARK: * Region
//*============================================================================*

@usableFromInline final class Region {
    @usableFromInline static let cache = NSCache<NSString, Region>()
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let formatter: NumberFormatter
    @usableFromInline private(set) var signs = Lexicon<Sign>()
    @usableFromInline private(set) var digits = Lexicon<Digit>()
    @usableFromInline private(set) var separators = Lexicon<Separator>()

    //=------------------------------------------------------------------------=
    // MARK: Accessors
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
        // MARK: Separators
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
        
        @usableFromInline var values:     [Character: Value] = [:]
        @usableFromInline var characters: [Value: Character] = [:]
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init() { }
        
        //=--------------------------------------------------------------------=
        // MARK: Subscripts
        //=--------------------------------------------------------------------=
        
        @inlinable subscript(character: Character) -> Value? {
            _read   { yield  values[character] }
            _modify { yield &values[character] }
        }
        
        @inlinable subscript(value: Value) -> Character? {
            _read   { yield  characters[value] }
            _modify { yield &characters[value] }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=

        @inlinable mutating func link(_ character: Character, _ value: Value) {
            values[character] = value
            characters[value] = character
        }
        
        @inlinable mutating func link(_ value: Value, _ character: Character) {
            values[character] = value
            characters[value] = character
        }
    }
}
