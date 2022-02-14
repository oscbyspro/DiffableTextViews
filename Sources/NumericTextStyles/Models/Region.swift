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
import Support

//*============================================================================*
// MARK: * Region
//*============================================================================*

@usableFromInline final class Region {
    
    //=------------------------------------------------------------------------=
    // MARK: Cache
    //=------------------------------------------------------------------------=
    
    @usableFromInline static private(set) var cacheHasBeenSetup = false

    @usableFromInline static let cache: NSCache<NSString, Region> = {
        let cache = NSCache<NSString, Region>(); cache.countLimit = 3; return cache
    }()
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let en_US = Region(
        locale: Locale(identifier: "en_US"),
        signs: Lexicon(ascii: Sign.self),
        digits: Lexicon(ascii: Digit.self),
        separators: Lexicon(ascii: Separator.self)
    )
    
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
    
    /// Creates an uncached region. Unit tests assert that it always succeeds.
    @inlinable convenience init(_ locale: Locale) throws {
        //=--------------------------------------=
        // MARK: Formatter
        //=--------------------------------------=
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        //=--------------------------------------=
        // MARK: Signs
        //=--------------------------------------=
        var signs = Lexicon<Sign>()
        try signs.link(Self.positive(in: formatter), .positive)
        try signs.link(Self.negative(in: formatter), .negative)
        //=--------------------------------------=
        // MARK: Digits
        //=--------------------------------------=
        var digits = Lexicon<Digit>()
        for digit in Digit.allCases {
            try digits.link(Self.digit(digit, in: formatter), digit)
        }
        //=--------------------------------------=
        // MARK: Separators
        //=--------------------------------------=
        var separators = Lexicon<Separator>()
        try separators.link(Self.fraction(in: formatter), .fraction)
        try separators.link(Self.grouping(in: formatter), .grouping)
        //=--------------------------------------=
        // MARK: Initialize
        //=--------------------------------------=
        self.init(locale: locale, signs: signs, digits: digits, separators: separators)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
    
    @inlinable static func positive(in formatter: NumberFormatter) throws -> Character {
        try unwrap(formatter.plusSign.filter(signable).first)
    }
    
    @inlinable static func negative(in formatter: NumberFormatter) throws -> Character {
        try unwrap(formatter.minusSign.filter(signable).first)
    }
    
    @inlinable static func digit(_ digit: Digit, in formatter: NumberFormatter) throws -> Character {
        try unwrap(formatter.string(from: digit.numericValue as NSNumber)?.first)
    }
    
    @inlinable static func fraction(in formatter: NumberFormatter) throws -> Character {
        try unwrap(formatter.decimalSeparator.first)
    }
    
    @inlinable static func grouping(in formatter: NumberFormatter) throws -> Character {
        try unwrap(formatter.groupingSeparator.first)
    }

    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable static func signable(character: Character) -> Bool {
        character.isPunctuation || character.isMathSymbol
    }
    
    @inlinable static func unwrap(_ character: Character?) throws -> Character {
        if let character = character { return character }
        throw Info(["unable to fetch localized character for component"])
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Cache
//=----------------------------------------------------------------------------=

extension Region {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Cache
    //=------------------------------------------------------------------------=
    
    @inlinable static func cached(_ locale: Locale) -> Region {
        setup()
        //=--------------------------------------=
        // MARK: Key
        //=--------------------------------------=
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
            let instance = Region.defaultable(locale)
            self.cache.setObject(instance, forKey: key)
            return instance
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    @inlinable static func setup() {
        guard !cacheHasBeenSetup else { return }
        self.cacheHasBeenSetup = true
        //=--------------------------------------=
        // MARK: Instantiate And Cache Constants
        //=--------------------------------------=
        self.cache.setObject(en_US, forKey: NSString(string: en_US.locale.identifier))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable static func defaultable(_ locale: Locale) -> Region {
        //=--------------------------------------=
        // MARK: Attempt
        //=--------------------------------------=
        attempt: do {
            return try Region(locale)
        //=--------------------------------------=
        // MARK: Default To Region.en_US (ASCII)
        //=--------------------------------------=
        } catch let reason {
            Info.print(["Region set to en_US:", .note(reason)])
            return Region.en_US
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Parse
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

    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    @inlinable func value<F: Format>(in number: Number, as format: F) throws -> F.Value {
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
