//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * Scheme x Currency
//*============================================================================*

@usableFromInline final class NumericTextSchemeXCurrency: Schemes.Reuseable {
    @usableFromInline static let cache = Cache<ID, NumericTextSchemeXCurrency>(33)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let id: ID
    @usableFromInline let lexicon: Lexicon
    @usableFromInline let preferences: Preferences
    @usableFromInline let instruction: Instruction?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ id: ID) {
        let formatter = NumberFormatter()
        formatter.locale = id.locale
        formatter.currencyCode = id.code
        assert(formatter.numberStyle == .none)
        //=--------------------------------------=
        // MARK: Instantiate - None
        //=--------------------------------------=
        self.id = id
        self.lexicon = .currency(formatter)
        //=--------------------------------------=
        // MARK: Instantiate - Currency
        //=--------------------------------------=
        formatter.numberStyle = .currency
        self.preferences = Preferences(formatter)
        self.instruction = Instruction(id, lexicon)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func reuse<T>(_ format: T) -> Self where T: Formats.Currency {
        reuse(ID(format.locale, format.currencyCode))
    }
    
    //*========================================================================*
    // MARK: * ID
    //*========================================================================*

    @usableFromInline struct ID: Hashable {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let code:   String
        @usableFromInline let locale: Locale

        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ locale: Locale, _ code: String) {
            self.locale = locale; self.code = code
        }
    }
    
    //*========================================================================*
    // MARK: * Preferences
    //*========================================================================*
    
    @usableFromInline struct Preferences {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let fraction: ClosedRange<Int>
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_   formatter: NumberFormatter) {
            self.fraction = formatter.minimumFractionDigits ...
                            formatter.maximumFractionDigits
        }
    }
    
    //*========================================================================*
    // MARK: * Instruction
    //*========================================================================*

    /// A model for marking currency labels as virtual.
    ///
    /// The characters used to express currencies are usually disjoint
    /// from the characters used to express their amounts, but sometimes they include fraction separators.
    /// This instruction is used to efficiently mark faux fraction separators, when they exist.
    ///
    @usableFromInline struct Instruction {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let occurances: Int
        @usableFromInline let character: Character
        @usableFromInline let direction: Direction

        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init?<S>(_ label: S, _ character: Character,
        _ direction: Direction) where S: Sequence, S.Element == Character {
            self.occurances = label.count(where: { $0 == character })
            //=--------------------------------------=
            // MARK: Validate
            //=--------------------------------------=
            guard occurances > 0 else { return nil }
            //=--------------------------------------=
            // MARK: Instantiate
            //=--------------------------------------=
            self.character = character
            self.direction = direction
        }
        
        @inlinable init?(_ id: ID, _ lexicon: Lexicon) {
            let separator = lexicon.separators[.fraction]
            let labels = IntegerFormatStyle<Int>
            .Currency(code: id.code, locale: id.locale)
            .precision(.fractionLength(0)).format(0).split(
            separator: lexicon.digits[.zero],
            omittingEmptySubsequences: false)
            //=----------------------------------=
            // MARK: Instantiate
            //=----------------------------------=
            if      let instance = Self(labels[0], separator,  .forwards) { self = instance }
            else if let instance = Self(labels[1], separator, .backwards) { self = instance }
            else { return nil }
        }
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        @inlinable func autocorrect(_ snapshot: inout Snapshot) {
            switch direction {
            case  .forwards: autocorrect(&snapshot, indices: snapshot.indices)
            case .backwards: autocorrect(&snapshot, indices: snapshot.indices.reversed())
            }
        }
        
        @inlinable func autocorrect<S>(_ snapshot: inout Snapshot,
        indices: S) where S: Sequence, S.Element == Snapshot.Index {
            var count = 0; for index in indices where
            snapshot[index].character == character {
                snapshot.update(attributes: index) { $0 = .phantom }
                count += 1; guard count < occurances else { return }
            }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Scheme
//=----------------------------------------------------------------------------=

extension NumericTextSchemeXCurrency {
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ snapshot: inout Snapshot) {
        instruction?.autocorrect(&snapshot)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Preferences
    //=------------------------------------------------------------------------=
    
    @inlinable func precision<T>(_ value: T.Type) -> Precision<T> where T: Value {
        Precision(fraction: preferences.fraction)
    }
}
