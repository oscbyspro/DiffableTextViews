//
//  Region.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import Foundation

#warning("Rename, maybe.")

//*============================================================================*
// MARK: * Region
//*============================================================================*

@usableFromInline final class Region {
    @usableFromInline static var cache = [String: Region]()
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let formatter: NumberFormatter
    @inlinable var locale: Locale { formatter.locale }
    
    //
    // MARK: Properties - Characters
    //=------------------------------------------------------------------------=
    
    @usableFromInline let signs:      [Character: Sign]
    @usableFromInline let signsLocal: [Sign: Character]
    
    @usableFromInline let digits:      [Character: Digit]
    @usableFromInline let digitsLocal: [Digit: Character]
    
    @usableFromInline let separators:      [Character: Separator]
    @usableFromInline let separatorsLocal: [Separator: Character]
    
    //=----------------------------------------------------------------------------=
    // MARK: Subscripts
    //=----------------------------------------------------------------------------=
    
    @inlinable subscript(sign: Sign) -> Character? {
        _read { yield signsLocal[sign] }
    }
    
    @inlinable subscript(digit: Digit) -> Character? {
        _read { yield digitsLocal[digit] }
    }
    
    @inlinable subscript(separator: Separator) -> Character? {
        _read { yield separatorsLocal[separator] }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ locale: Locale) {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        
        //=--------------------------------------=
        // MARK: Characters - Signs
        //=--------------------------------------=
        
        var signs      = [Character: Sign]()
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
        var digitsLocal = [Digit: Character]()
        
        for digit in Digit.allCases {
            digits[digit.rawValue] = digit
            
            let digitLocal = formatter.string(from: UInt8(String(digit.rawValue))! as NSNumber)!.first!
            digits[digitLocal] = digit
            digitsLocal[digit] = digitLocal
        }
        
        //=--------------------------------------=
        // MARK: Characters - Separators
        //=--------------------------------------=
    
        var separators      = [Character: Separator]()
        var separatorsLocal = [Separator: Character]()
        
        separators[Separator.fraction.rawValue] = .fraction
        separators[Separator.grouping.rawValue] = .grouping
        
        let fractionLocal = formatter.decimalSeparator.first!
        separators[fractionLocal] = .fraction
        separatorsLocal[.fraction] = fractionLocal
        
        let groupingLocal = formatter.groupingSeparator.first!
        separators[groupingLocal] = .grouping
        separatorsLocal[.grouping] = groupingLocal

        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        
        self.formatter = formatter
        
        self.signs      = signs
        self.signsLocal = signsLocal
        
        self.digits      = digits
        self.digitsLocal = digitsLocal
        
        self.separators      = separators
        self.separatorsLocal = separatorsLocal
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
