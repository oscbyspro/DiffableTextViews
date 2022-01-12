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
    @usableFromInline static var cache = [String: Region]()
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let formatter: NumberFormatter
    @usableFromInline let direction: Locale.LanguageDirection
        
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

        let direction = Locale.characterDirection(forLanguage: locale.languageCode!)
        
        //=--------------------------------------=
        // MARK: Characters - Signs
        //=--------------------------------------=
        
        var signs = [Character: Sign]()
        var signsLocal = [Sign: Character]()
        
        signs[Sign.positive.rawValue] = .positive
        signs[Sign.negative.rawValue] = .negative
        
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
            digits[digit.rawValue] = digit
            
            let digitInLocale = formatter.string(from: UInt8(String(digit.rawValue))! as NSNumber)!.first!
            digits[digitInLocale] = digit
            digitsInLocale[digit] = digitInLocale
        }
        
        //=--------------------------------------=
        // MARK: Characters - Separators
        //=--------------------------------------=
    
        var separators = [Character: Separator]()
        var separatorsInLocale = [Separator: Character]()
        
        separators[Separator.fraction.rawValue] = .fraction
        separators[Separator.grouping.rawValue] = .grouping
        
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
        self.direction = direction
        
        self.signs = signs
        self.signsInLocale = signsLocal
        
        self.digits = digits
        self.digitsInLocale = digitsInLocale
        
        self.separators = separators
        self.separatorsInLocale = separatorsInLocale
                
    }
    
    //
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    #warning("Limit cache size, maybe.")
    @inlinable static func reusable(_ locale: Locale) -> Region {
        if let reusable = cache[locale.identifier] {
            return reusable
        } else {
            let instance = Region(locale)
            cache[locale.identifier] = instance
            return instance
        }
    }
}
