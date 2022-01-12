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
    @usableFromInline let digits:     [Character: Digit]
    @usableFromInline let separators: [Character: Separator]

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ locale: Locale) {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        
        //=--------------------------------------=
        // MARK: Characters - Signs
        //=--------------------------------------=
        
        var signs = [Character: Sign]()
        signs[Sign.positive.rawValue] = .positive
        signs[Sign.negative.rawValue] = .negative
        signs[formatter .plusSign.filter({ $0.isPunctuation || $0.isMathSymbol }).first!] = .positive
        signs[formatter.minusSign.filter({ $0.isPunctuation || $0.isMathSymbol }).first!] = .negative
                        
        //=--------------------------------------=
        // MARK: Characters - Digits
        //=--------------------------------------=
        
        var digits = [Character: Digit]()
        for digit in Digit.allCases {
            digits[digit.rawValue] = digit
            digits[formatter.string(from: UInt8(String(digit.rawValue))! as NSNumber)!.first!] = digit
        }
        
        //=--------------------------------------=
        // MARK: Characters - Separators
        //=--------------------------------------=
    
        var separators = [Character: Separator]()
        separators[formatter .decimalSeparator.first!] = .fraction
        separators[formatter.groupingSeparator.first!] = .grouping

        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        
        self.formatter = formatter
        self.signs = signs
        self.digits = digits
        self.separators = separators
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
