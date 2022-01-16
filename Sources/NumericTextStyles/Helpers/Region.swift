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
        
    //
    // MARK: Properties - Characters
    //=------------------------------------------------------------------------=
    
    @usableFromInline let signs: [Character: Sign]
    @usableFromInline let signsInLocale: [Sign: Character]
    
    @usableFromInline let digits: [Character: Digit]
    @usableFromInline let digitsInLocale: [Digit: Character]
    
    @usableFromInline let separators: [Character: Separator]
    @usableFromInline let separatorsInLocale: [Separator: Character]
    
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
        
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        
        //=--------------------------------------=
        // MARK: Characters - Signs
        //=--------------------------------------=
        
        var signs = [Character: Sign]()
        var signsLocal = [Sign: Character]()
        
        signs[Sign.positive.character] = .positive
        signs[Sign.negative.character] = .negative
        
        let positiveLocal = formatter .plusSign.filter({ $0.isPunctuation || $0.isMathSymbol }).first!
        signs[positiveLocal] = .positive
        signsLocal[.positive] = positiveLocal
        
        let negativeLocal = formatter.minusSign.filter({ $0.isPunctuation || $0.isMathSymbol }).first!
        signs[negativeLocal] = .negative
        signsLocal[.negative] = negativeLocal
                        
        //=--------------------------------------=
        // MARK: Characters - Digits
        //=--------------------------------------=
        
        var digits = [Character: Digit]()
        var digitsInLocale = [Digit: Character]()
        
        for digit in Digit.allCases {
            digits[digit.character] = digit
            
            let digitInLocale = formatter.string(from: digit.uInt8 as NSNumber)!.first!
            digits[digitInLocale] = digit
            digitsInLocale[digit] = digitInLocale
        }
        
        //=--------------------------------------=
        // MARK: Characters - Separators
        //=--------------------------------------=
    
        var separators = [Character: Separator]()
        var separatorsInLocale = [Separator: Character]()
        
        separators[Separator.fraction.character] = .fraction
        separators[Separator.grouping.character] = .grouping
        
        let fractionInLocale = formatter.decimalSeparator.first!
        separators[fractionInLocale] = .fraction
        separatorsInLocale[.fraction] = fractionInLocale
        
        let groupingInLocale = formatter.groupingSeparator.first!
        separators[groupingInLocale] = .grouping
        separatorsInLocale[.grouping] = groupingInLocale

        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        
        self.formatter = formatter
        
        self.signs = signs
        self.signsInLocale = signsLocal
        
        self.digits = digits
        self.digitsInLocale = digitsInLocale
        
        self.separators = separators
        self.separatorsInLocale = separatorsInLocale
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
        signsInLocale[number.sign]!.write(to: &characters)
        //=--------------------------------------=
        // MARK: Integer Digits
        //=--------------------------------------=
        for digit in number.integer.digits {
            print(digit, digitsInLocale[digit]!)
            digitsInLocale[digit]!.write(to: &characters)
        }
        //=--------------------------------------=
        // MARK: Fraction Separator
        //=--------------------------------------=
        if let separator = number.separator {
            separatorsInLocale[separator]!.write(to: &characters)
            //=----------------------------------=
            // MARK: Fraction Digits
            //=----------------------------------=
            print()
            for digit in number.fraction.digits {
                print(digit)
                digitsInLocale[digit]!.write(to: &characters)
            }
        }
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return characters
    }
}
