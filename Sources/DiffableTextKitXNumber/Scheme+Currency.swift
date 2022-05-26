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

@usableFromInline final class NumberTextSchemeXCurrency: NumberTextSchemeXReuseable {
    @usableFromInline static let cache = Cache<ID, NumberTextSchemeXCurrency>(32)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let id: ID
    @usableFromInline let reader: Reader
    @usableFromInline let preferences: Preferences
    @usableFromInline let adjustments: Adjustments?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ id: ID) {
        //=--------------------------------------=
        // Formatter
        //=--------------------------------------=
        let formatter = NumberFormatter()
        formatter.locale = id.locale
        formatter.currencyCode = id.code
        assert(formatter.numberStyle == .none)
        //=--------------------------------------=
        // Formatter: None
        //=--------------------------------------=
        self.id = id
        self.reader = Reader(.currency(formatter))
        //=--------------------------------------=
        // Formatter: Currency
        //=--------------------------------------=
        formatter.numberStyle = .currency
        self.preferences = Preferences(formatter)
        formatter.maximumFractionDigits = .zero
        self.adjustments = Adjustments(formatter, reader.components)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func reuse<T>(_ format: T) -> Self
    where T: NumberTextFormatXCurrency {
        reuse(ID(format.locale, format.currencyCode))
    }
    
    //*========================================================================*
    // MARK: ID
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
    // MARK: Preferences
    //*========================================================================*
    
    @usableFromInline struct Preferences {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let fraction: ClosedRange<Int>
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        /// - Requires that formatter.numberStyle == .currency.
        /// - Requires that formatter.maximumFractionDigits == default.
        ///
        @inlinable init(_   formatter: NumberFormatter) {
            self.fraction = formatter.minimumFractionDigits ...
                            formatter.maximumFractionDigits
        }
    }
    
    //*========================================================================*
    // MARK: Adjustments
    //*========================================================================*

    /// A model for marking currency symbols as virtual when necessary.
    @usableFromInline struct Adjustments {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let label: String
        @usableFromInline let direction: Direction

        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        /// Returns an instance if it is needed, returns nil otherwise.
        ///
        /// Correctness is assert by tests parsing currency formats for all locale-currency pairs.
        ///
        /// - Requires that formatter.numberStyle == .currency.
        /// - Requires that formatter.maximumFractionDigits == .zero.
        ///
        @inlinable init?(_ formatter: NumberFormatter, _ components: Components) {
            self.label = formatter.currencySymbol
            //=----------------------------------=
            // Necessity
            //=----------------------------------=
            guard label.contains(components.separators[.fraction]) else { return nil }
            //=----------------------------------=
            // Formatted
            //=----------------------------------=
            let sides = formatter.string(from: 0)!.split(
            separator: components.digits[.zero],
            omittingEmptySubsequences:   false)
            //=----------------------------------=
            // Direction
            //=----------------------------------=
            switch sides[0].contains(label) {
            case  true: self.direction =  .forwards
            case false: self.direction = .backwards; assert(sides[1].contains(label))
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable func autocorrect(_ snapshot: inout Snapshot) {
            if let range = Search.range(of: label, in: snapshot, towards: direction) {
                snapshot.transform(attributes: range) { $0 = .phantom }
            }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension NumberTextSchemeXCurrency {
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ snapshot: inout Snapshot) {
        adjustments?.autocorrect(&snapshot)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Preferences
    //=------------------------------------------------------------------------=
    
    @inlinable func preferred<T>(_ value: T.Type) -> NumberTextPrecision<T> {
        NumberTextPrecision(fraction: preferences.fraction)
    }
}
