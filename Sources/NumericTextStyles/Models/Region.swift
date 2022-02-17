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

#warning("Maybe have a normal cache and a currencies cache.")
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
        signs: .ascii(), digits: .ascii(), separators: .ascii()
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
        self.locale = locale; self.signs = signs; self.digits = digits; self.separators = separators
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Indirect
    //=------------------------------------------------------------------------=
    
    /// Creates an uncached region. Unit tests assert that it always succeeds.
    @inlinable convenience init(_ locale: Locale) throws {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        //=--------------------------------------=
        // MARK: Initialize
        //=--------------------------------------=
        try self.init(locale: locale,   signs: .local(formatter),
        digits: .local(formatter), separators: .local(formatter))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Cache
//=----------------------------------------------------------------------------=

extension Region {
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    @inlinable static func setup() {
        guard !cacheHasBeenSetup else { return }; self.cacheHasBeenSetup = true
        self.cache.setObject(en_US, forKey: en_US.locale.identifier as NSString)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func cached(_ locale: Locale) -> Region {
        setup(); let key = locale.identifier as NSString
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
            cache.setObject(instance, forKey: key)
            return instance
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static - Helpers
    //=------------------------------------------------------------------------=

    @inlinable static func defaultable(_ locale: Locale) -> Region {
        instance: do { return try Region(locale)
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
    // MARK: Number -> Value
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
        print(characters, try? format.parse(characters))
        print(number.sign, number.integer, number.separator, number.fraction)
        return try format.parse(characters)
    }
    
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
