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
    
    @usableFromInline let locale: Locale
    
    //
    // MARK: Properties - Signs
    //=------------------------------------------------------------------------=
    
    @usableFromInline let signs: Set<Character>
    
    //
    // MARK: Properties - Digits
    //=------------------------------------------------------------------------=
    
    @usableFromInline let zero: Character
    @usableFromInline let digits: Set<Character>
    
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
        formatter.usesGroupingSeparator = false
        
        //=--------------------------------------=
        // MARK: Locale
        //=--------------------------------------=
        
        self.locale = locale
        
        //=--------------------------------------=
        // MARK: Generate Localized - Signs
        //=--------------------------------------=
        
        var signs = Set<Character>()
        signs.insert(formatter .plusSign.filter({ $0.isPunctuation || $0.isMathSymbol }).first!)
        signs.insert(formatter.minusSign.filter({ $0.isPunctuation || $0.isMathSymbol }).first!)
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
