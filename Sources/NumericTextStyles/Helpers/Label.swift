//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation
import DiffableTextViews
import Support

//*============================================================================*
// MARK: * Label
//*============================================================================*

/// A collection of characters at or near the end in some formatted text.
public final class Label {
    
    //=------------------------------------------------------------------------=
    // MARK: Cache
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let currencies: NSCache<ID, Label> = {
        let cache = NSCache<ID, Label>(); cache.countLimit = 33; return cache
    }()
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let characters: String
    @usableFromInline let location: Location
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init<S: StringProtocol>(_ characters: S, at location: Location) {
        self.location = location
        self.characters = String(characters)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Naive search is OK because labels are close to the edge and unique from edge to end.
    @inlinable func range(in snapshot: Snapshot) -> Range<Snapshot.Index>? {
        Search.range(of: characters, in: snapshot, reversed: location == .suffix)
    }
    
    //*========================================================================*
    // MARK: * Location
    //*========================================================================*
    
    @usableFromInline enum Location { case prefix, suffix }
    
    //*========================================================================*
    // MARK: * ID
    //*========================================================================*
    
    @usableFromInline final class ID: Hashable {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let code:   String
        @usableFromInline let locale: String
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(code: String, locale: String) {
            self.code = code
            self.locale = locale
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Hashable
        //=--------------------------------------------------------------------=
        
        @inlinable func hash(into hasher: inout Hasher) {
            hasher.combine(code)
            hasher.combine(locale)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Comparisons
        //=--------------------------------------------------------------------=
        
        @inlinable static func == (lhs: ID, rhs: ID) -> Bool {
            lhs.code == rhs.code && lhs.locale == rhs.locale
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Currency
//=----------------------------------------------------------------------------=

extension Label {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func currency(code: String, in lexicon: Lexicon) -> Label {
        let key = ID(code: code, locale: lexicon.locale.identifier)
        //=--------------------------------------=
        // MARK: Search In Cache
        //=--------------------------------------=
        if let reusable = currencies.object(forKey: key) {
            return reusable
        //=--------------------------------------=
        // MARK: Make A New Instance And Save It
        //=--------------------------------------=
        } else {
            let instance = Label.currency(code: code, in: lexicon)
            currencies.setObject(instance, forKey: key)
            return instance
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable static func _currency(code: String, in lexicon: Lexicon) -> Label {
        let digit = lexicon.digits[.zero]
        //=--------------------------------------=
        // MARK: Split
        //=--------------------------------------=
        let split = IntegerFormatStyle<Int>
            .Currency(code: code).locale(lexicon.locale)
            .precision(.fractionLength(0)).format(0)
            .split(separator: digit, omittingEmptySubsequences: false)
        //=--------------------------------------=
        // MARK: Check
        //=--------------------------------------=
        guard split.count == 2 else {
            fatalError(Info([.mark(digit), "is not in", .mark(split)]).description)
        }
        //=--------------------------------------=
        // MARK: Instance
        //=--------------------------------------=
        #warning("Double-check.")
        return !split[0].filter(\.isWhitespace).isEmpty
        ? Label(split[0], at: .prefix)
        : Label(split[1], at: .suffix)
    }
}
