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

#warning("Make new tests for changes.")
#warning("Make a test to see that all locales map to a region.")
#warning("Make locale initializer fallible.")
//*============================================================================*
// MARK: * Region
//*============================================================================*

@usableFromInline final class Region {
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let cache: NSCache<NSString, Region> = {
        let cache = NSCache<NSString, Region>(); cache.countLimit = 3; return cache
    }()
    
    @usableFromInline static let ascii: Region = {
        let identifier = "en_US"
        let region = Region.init(
        locale: Locale(identifier: identifier),
        signs: Lexicon(ascii: Sign.self),
        digits: Lexicon(ascii: Digit.self),
        separators: Lexicon(ascii: Separator.self))
        cache.setObject(region, forKey: NSString(string: identifier))
        return region
    }()
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let locale: Locale
    @usableFromInline let signs: Lexicon<Sign>
    @usableFromInline let digits: Lexicon<Digit>
    @usableFromInline let separators: Lexicon<Separator>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale, signs: Lexicon<Sign>, digits: Lexicon<Digit>, separators: Lexicon<Separator>) {
        self.locale = locale
        self.signs = signs
        self.digits = digits
        self.separators = separators
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Locale
    //=------------------------------------------------------------------------=
    
    /// Creates an uncached region.
    ///
    /// It force unwraps characters, so its validity should be asserted by unit tests for all locales.
    ///
    @inlinable convenience init(_ locale: Locale) {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        //=--------------------------------------=
        // MARK: Signs
        //=--------------------------------------=
        var signs = Self.ascii.signs
        signs.link(formatter .plusSign.filter({ $0.isPunctuation || $0.isMathSymbol }).first!, .positive)
        signs.link(formatter.minusSign.filter({ $0.isPunctuation || $0.isMathSymbol }).first!, .negative)
        //=--------------------------------------=
        // MARK: Digits
        //=--------------------------------------=
        var digits = Self.ascii.digits
        for digit in Digit.allCases {
            digits.link(formatter.string(from: digit.numericValue as NSNumber)!.first!, digit)
        }
        //=--------------------------------------=
        // MARK: Separators
        //=--------------------------------------=
        var separators = Self.ascii.separators
        separators.link(formatter .decimalSeparator.first!, .fraction)
        separators.link(formatter.groupingSeparator.first!, .grouping)
        //=--------------------------------------=
        // MARK: Set
        //=--------------------------------------=
        self.init(locale: locale, signs: signs, digits: digits, separators: separators)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Cache
    //=------------------------------------------------------------------------=
    
    @inlinable static func cached(_ locale: Locale) -> Region {
        let key = NSString(string: locale.identifier)
        //=--------------------------------------=
        // MARK: Search In Cache
        //=--------------------------------------=
        if let reusable = cache.object(forKey: key) {
            return reusable
        //=--------------------------------------=
        // MARK: Make A New Instance And Save It
        //=--------------------------------------=
        } else {
            let instance = Region(locale)
            cache.setObject(instance, forKey: key)
            return instance
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Parse: Number
//=----------------------------------------------------------------------------=

extension Region {

    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    @inlinable func value<F: Format>(in number:  Number, as format: F) throws -> F.Value {
        var characters = String()
        //=--------------------------------------=
        // MARK: Sign
        //=--------------------------------------=
        signs[number.sign].write(to: &characters)
        //=--------------------------------------=
        // MARK: Integer Digits
        //=--------------------------------------=
        for digit in number.integer.digits {
            digits[digit].write(to: &characters)
        }
        //=--------------------------------------=
        // MARK: Fraction Separator
        //=--------------------------------------=
        if let separator = number.separator {
            separators[separator].write(to: &characters)
            //=----------------------------------=
            // MARK: Fraction Digits
            //=----------------------------------=
            for digit in number.fraction.digits {
                digits[digit].write(to: &characters)
            }
        }
        //=--------------------------------------=
        // MARK: Characters -> Value
        //=--------------------------------------=
        return try format.parse(characters)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Parse: Snapshot
//=----------------------------------------------------------------------------=

extension Region {
    
    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    /// To use this method, all formatting characters must be marked as virtual.
    @inlinable func number<V: Value>(in snapshot: Snapshot, as value: V.Type) throws -> Number {
        let characters = snapshot.lazy.filter(\.nonvirtual).map(\.character)
        return try .init(characters: characters, integer: V.isInteger, unsigned: V.isUnsigned,
        signs: signs.components, digits: digits.components, separators: separators.components)
    }
}
