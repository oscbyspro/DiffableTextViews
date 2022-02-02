//
//  Region.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import DiffableTextViews
import Foundation

//*============================================================================*
// MARK: * Region
//*============================================================================*

@usableFromInline final class Region {
    @usableFromInline static let cache = NSCache<NSString, Region>()
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let locale: Locale
    @usableFromInline private(set) var signs = Lexicon<Sign>()
    @usableFromInline private(set) var digits = Lexicon<Digit>()
    @usableFromInline private(set) var separators = Lexicon<Separator>()

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates an uncached region.
    ///
    /// It force unwraps characters. Validity should be asserted by unit tests for all locales.
    ///
    @inlinable init(_ locale: Locale) {
        //=--------------------------------------=
        // MARK: Locale
        //=--------------------------------------=
        self.locale = locale
        //=--------------------------------------=
        // MARK: Formatter
        //=--------------------------------------=
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        //=--------------------------------------=
        // MARK: Signs
        //=--------------------------------------=
        self.signs = Lexicon<Sign>()
        self.signs.merge(Sign.system)
        self.signs.link(formatter .plusSign.filter({ $0.isPunctuation || $0.isMathSymbol }).first!, .positive)
        self.signs.link(formatter.minusSign.filter({ $0.isPunctuation || $0.isMathSymbol }).first!, .negative)
        //=--------------------------------------=
        // MARK: Digits
        //=--------------------------------------=
        self.digits = Lexicon<Digit>()
        self.digits.merge(Digit.system)
        for digit in Digit.allCases {
            self.digits.link(formatter.string(from: digit.number as NSNumber)!.first!, digit)
        }
        //=--------------------------------------=
        // MARK: Separators
        //=--------------------------------------=
        self.separators = Lexicon<Separator>()
        self.separators.merge(Separator.system)
        self.separators.link(formatter .decimalSeparator.first!, .fraction)
        self.separators.link(formatter.groupingSeparator.first!, .grouping)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func cached(_ locale: Locale) -> Region {
        let key = NSString(string: locale.identifier)
        //=--------------------------------------=
        // MARK: Search In Cache
        //=--------------------------------------=
        if let reusable = cache.object(forKey: key) {
            return reusable
        //=--------------------------------------=
        // MARK: Create A New Instance
        //=--------------------------------------=
        } else {
            let instance = Region(locale)
            cache.setObject(instance, forKey: key)
            return instance
        }
    }
    
    //*========================================================================*
    // MARK: * Lexicon
    //*========================================================================*
    
    @usableFromInline struct Lexicon<Component: Hashable> {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var components: [Character: Component] = [:]
        @usableFromInline var characters: [Component: Character] = [:]
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init() { }
        
        //=--------------------------------------------------------------------=
        // MARK: Subscripts
        //=--------------------------------------------------------------------=
        
        @inlinable subscript(character: Character) -> Component? {
            _read   { yield  components[character] }
            _modify { yield &components[character] }
        }
        
        @inlinable subscript(component: Component) -> Character? {
            _read   { yield  characters[component] }
            _modify { yield &characters[component] }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=

        @inlinable mutating func merge(_ other: [Character: Component]) {
            self.components.merge(other) { $1 }
        }
        
        @inlinable mutating func link(_ character: Character, _ component: Component) {
            self.components[character] = component
            self.characters[component] = character
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Region - Number
//=----------------------------------------------------------------------------=

extension Region {
    
    //=------------------------------------------------------------------------=
    // MARK: Number To Characters
    //=------------------------------------------------------------------------=
    
    /// Converts a number to regional characters, to be parsed by a localized format style.
    ///
    /// - Characters do not include right-to-left markers (which are redundant for parsing).
    ///
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
    
    //=------------------------------------------------------------------------=
    // MARK: Components To Number
    //=------------------------------------------------------------------------=
    
    @inlinable func number<T: Value>(in snapshot: Snapshot, as value: T.Type) throws -> Number {
        let characters = snapshot.lazy.filter(\.nonvirtual).map(\.character)
        return try Number(characters: characters, integer: T.isInteger, unsigned: T.isUnsigned,
        signs: signs.components, digits: digits.components, separators: separators.components)
    }
}
