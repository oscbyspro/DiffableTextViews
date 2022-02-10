//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import Foundation

//*============================================================================*
// MARK: * Region
//*============================================================================*

@usableFromInline final class Region {
    
    //=------------------------------------------------------------------------=
    // MARK: Cache
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let cache: NSCache<NSString, Region> = {
        let cache = NSCache<NSString, Region>(); cache.countLimit = 3; return cache
    }()
    
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
            self.digits.link(formatter.string(from: digit.numericValue as NSNumber)!.first!, digit)
        }
        //=--------------------------------------=
        // MARK: Separators
        //=--------------------------------------=
        self.separators = Lexicon<Separator>()
        self.separators.merge(Separator.system)
        self.separators.link(formatter .decimalSeparator.first!, .fraction)
        self.separators.link(formatter.groupingSeparator.first!, .grouping)
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
// MARK: Region - Cache
//=----------------------------------------------------------------------------=

extension Region {
    
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
        // MARK: Create A New Instance An Save It
        //=--------------------------------------=
        } else {
            let instance = Region(locale)
            cache.setObject(instance, forKey: key)
            return instance
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Region - Parse
//=----------------------------------------------------------------------------=

extension Region {

    //=------------------------------------------------------------------------=
    // MARK: Number -> Value
    //=------------------------------------------------------------------------=
    
    @inlinable func value<F: NumericTextFormat>(in number:  Number, as format: F) throws -> F.Value {
        let characters = characters(in: number); return try format.parse(characters)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Number -> String
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
}

//=----------------------------------------------------------------------------=
// MARK: Region - Parse
//=----------------------------------------------------------------------------=

extension Region {
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot -> Number
    //=------------------------------------------------------------------------=
    
    /// To use this method, all formatting characters must be marked as virtual.
    @inlinable func number<V: Value>(in snapshot: Snapshot, as value: V.Type) throws -> Number {
        let characters = snapshot.lazy.filter(\.nonvirtual).map(\.character)
        return try .init(characters: characters, integer: V.isInteger, unsigned: V.isUnsigned,
        signs: signs.components, digits: digits.components, separators: separators.components)
    }
}
