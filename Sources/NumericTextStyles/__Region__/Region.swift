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
    // MARK: Properties - Signs
    //=------------------------------------------------------------------------=
    
    @usableFromInline let signs: [Character: Sign]
    
    //
    // MARK: Properties - Digits
    //=------------------------------------------------------------------------=
    
    @usableFromInline let zero: Character
    @usableFromInline let digits: [Character: Character]
    
    //
    // MARK: Properties - Separators
    //=------------------------------------------------------------------------=
    
    @usableFromInline let fractionSeparator: Character
    @usableFromInline let groupingSeparator: Character
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ locale: Locale) {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        
        //=--------------------------------------=
        // MARK: Formatter
        //=--------------------------------------=
        
        self.formatter = formatter
        
        //=--------------------------------------=
        // MARK: Generate Localized - Signs
        //=--------------------------------------=
        
        var signs = [Character: Sign]()
        signs[formatter .plusSign.filter({ $0.isPunctuation || $0.isMathSymbol }).first!] = .positive
        signs[formatter.minusSign.filter({ $0.isPunctuation || $0.isMathSymbol }).first!] = .negative
        self.signs = signs
        
        //=--------------------------------------=
        // MARK: Generate Localized - Digits
        //=--------------------------------------=
        
        let digits = formatter.string(from: 1234567890)!
        assert(digits.count == 10 && formatter.number(from: String(digits.last!)) == 0)
        
        self.zero = digits.last!
        self.digits = Set(digits)
        
        //=--------------------------------------=
        // MARK: Generate Localized - Separators
        //=--------------------------------------=
        
        assert(formatter.decimalSeparator.count == 1)
        self.fractionSeparator = formatter.decimalSeparator.first!
        
        assert(formatter.groupingSeparator.count == 1)
        self.groupingSeparator = formatter.groupingSeparator.first!
    }
    
    //
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
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
