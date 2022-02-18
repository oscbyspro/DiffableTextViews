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
// MARK: * Lexicon
//*============================================================================*

public final class Lexicon {
    @usableFromInline typealias Cache = NSCache<NSString, Lexicon>
    
    //=------------------------------------------------------------------------=
    // MARK: Cache
    //=------------------------------------------------------------------------=
    
    @usableFromInline static private(set) var complete = false
    
    @usableFromInline static let standard: Cache = {
        let cache = Cache(); cache.countLimit = 3; return cache
    }()
    
    @usableFromInline static let currency: Cache = {
        let cache = Cache(); cache.countLimit = 3; return cache
    }()
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let en_US = Lexicon(
        locale: Locale(identifier: "en_US"),
        signs: .ascii(), digits: .ascii(), separators: .ascii()
    )
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let locale: Locale
    @usableFromInline let signs: Links<Sign>
    @usableFromInline let digits: Links<Digit>
    @usableFromInline let separators: Links<Separator>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale, signs: Links<Sign>, digits: Links<Digit>, separators: Links<Separator>) {
        self.locale = locale
        self.signs = signs
        self.digits = digits
        self.separators = separators
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func standard(locale: Locale) -> Lexicon {
        search(locale, in: standard, default: try _standard(locale: locale))
    }
    
    @inlinable static func currency(code: String, locale: Locale) -> Lexicon {
        search(locale, in: currency, default: try _currency(code: code, locale: locale))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static - Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable static func _standard(locale: Locale) throws -> Self {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        //=--------------------------------------=
        // MARK: Initialize
        //=--------------------------------------=
        return   try .init(locale: locale, signs: .standard(formatter),
        digits: .standard(formatter), separators: .standard(formatter))
    }
    
    @inlinable static func _currency(code: String, locale: Locale) throws -> Self {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.currencyCode = code
        formatter.numberStyle = .decimal
        //=--------------------------------------=
        // MARK: Initialize
        //=--------------------------------------=
        return   try .init(locale: locale, signs: .currency(formatter),
        digits: .currency(formatter), separators: .currency(formatter))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Cache
//=----------------------------------------------------------------------------=

extension Lexicon {
    
    //=------------------------------------------------------------------------=
    // MARK: Search
    //=------------------------------------------------------------------------=
    
    @inlinable static func search(_ locale: Locale, in cache: Cache,
    default make: @autoclosure () throws -> Lexicon) -> Lexicon {
        //=--------------------------------------=
        // MARK: Setup, Key
        //=--------------------------------------=
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
            let instance = defaultable(try make())
            cache.setObject(instance, forKey: key)
            return instance
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    @inlinable static func setup() {
        guard !complete else { return }; complete = true
        self.standard.setObject(en_US, forKey: en_US.locale.identifier as NSString)
        self.currency.setObject(en_US, forKey: en_US.locale.identifier as NSString)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Error
    //=------------------------------------------------------------------------=
    
    @inlinable static func defaultable(_ make: @autoclosure () throws -> Lexicon) -> Lexicon {
        do { return try make()
        //=--------------------------------------=
        // MARK: Default To Lexicon.en_US (ASCII)
        //=--------------------------------------=
        } catch let reason {
            Info.print(["Lexicon set to en_US:", .note(reason)])
            return Lexicon.en_US
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Parse
//=----------------------------------------------------------------------------=

extension Lexicon {

    //=------------------------------------------------------------------------=
    // MARK: Number -> Value
    //=------------------------------------------------------------------------=
    
    @inlinable func value<F: Format>(in number: Number, as format: F) throws -> F.Value {
        try format.locale(Self.en_US.locale).parse(String(describing: number))
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
