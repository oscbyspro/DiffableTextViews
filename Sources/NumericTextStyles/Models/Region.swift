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
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let locale: Locale
    @usableFromInline let signs: Lexicon<Sign>
    @usableFromInline let digits: Lexicon<Digit>
    @usableFromInline let separators: Lexicon<Separator>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates an uncached region.
    ///
    /// It force unwraps characters. Validity should be asserted by unit tests for all locales.
    ///
    @inlinable init(_ locale: Locale) {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        //=--------------------------------------=
        // MARK: Signs
        //=--------------------------------------=
        var signs = Lexicon(ascii: Sign.self)
        signs.link(formatter .plusSign.filter({ $0.isPunctuation || $0.isMathSymbol }).first!, .positive)
        signs.link(formatter.minusSign.filter({ $0.isPunctuation || $0.isMathSymbol }).first!, .negative)
        //=--------------------------------------=
        // MARK: Digits
        //=--------------------------------------=
        var digits = Lexicon(ascii: Digit.self)
        for digit in Digit.allCases {
            digits.link(formatter.string(from: digit.numericValue as NSNumber)!.first!, digit)
        }
        //=--------------------------------------=
        // MARK: Separators
        //=--------------------------------------=
        var separators = Lexicon(ascii: Separator.self)
        separators.link(formatter .decimalSeparator.first!, .fraction)
        separators.link(formatter.groupingSeparator.first!, .grouping)
        //=--------------------------------------=
        // MARK: Set
        //=--------------------------------------=
        self.locale = locale
        self.signs = signs
        self.digits = digits
        self.separators = separators
    }
    
    //*========================================================================*
    // MARK: * Lexicon
    //*========================================================================*
    
    /// A mapping model between components and characters.
    ///
    /// - It requires that each component is bidirectionally mapped to a character.
    /// - To ensure an available input method, relevant ASCII must also map to a component.
    /// - ASCII characters should be added first, so they may be overriden by localized.
    ///
    @usableFromInline struct Lexicon<Component: Hashable> {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var components: [Character: Component]
        @usableFromInline var characters: [Component: Character]
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(components: [Character: Component] = [:], characters: [Component: Character] = [:]) {
            self.components = components
            self.characters = characters
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers - Indirect
        //=--------------------------------------------------------------------=

        @inlinable init(ascii: Component.Type) where Component: Unicodeable {
            self.init(components: Component.ascii)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Subscripts
        //=--------------------------------------------------------------------=
        
        @inlinable subscript(character: Character) -> Component? {
            _read   { yield  components[character] }
            _modify { yield &components[character] }
        }
        
        /// Bidirectional mapping is required for all components, so characters may be force unwrapped.
        @inlinable subscript(component: Component) -> Character {
            _read   { yield  characters[component]! }
            _modify { yield &characters[component]! }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        @inlinable mutating func link(_ character: Character, _ component: Component) {
            self.components[character] = component
            self.characters[component] = character
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Cache
//=----------------------------------------------------------------------------=

extension Region {
    
    //=------------------------------------------------------------------------=
    // MARK: Storage
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let cache: NSCache<NSString, Region> = {
        let cache = NSCache<NSString, Region>(); cache.countLimit = 3; return cache
    }()
    
    //=------------------------------------------------------------------------=
    // MARK: Search Or Make
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
        let characters = characters(in: number); return try format.parse(characters)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
    
    /// Converts a number to localized characters, to be parsed by a localized format style.
    ///
    /// - Output does not include right-to-left markers (which are redundant for parsing).
    ///
    @inlinable func characters(in number: Number) -> String {
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
        // MARK: Done
        //=--------------------------------------=
        return characters
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
