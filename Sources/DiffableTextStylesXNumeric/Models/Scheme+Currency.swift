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
    
    @usableFromInline let label: Label
    @usableFromInline let lexicon: Lexicon
    @usableFromInline let defaults: Defaults
    @usableFromInline let identifier: ID

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ identifier: ID) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = identifier.locale
        formatter.currencyCode = identifier.code
        //=--------------------------------------=
        // MARK: Instantiate
        //=--------------------------------------=
        self.identifier = identifier
        self.defaults = .init(formatter)
        self.lexicon = .currency(formatter)
        self.label = .currency(identifier.locale,
        code: identifier.code, lexicon: lexicon)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func reuseable<T>(_ format: T) -> Self where T: Formats.Currency {
        reuseable(ID(format.locale, format.currencyCode))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var code: String {
        identifier.code
    }
    
    @inlinable var locale: Locale {
        identifier.locale
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
    // MARK: * Defaults
    //*========================================================================*
    
    @usableFromInline struct Defaults {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let fractionLimits: ClosedRange<Int>
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ formatter: NumberFormatter) {
            self.fractionLimits =
            formatter.minimumFractionDigits ...
            formatter.maximumFractionDigits
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Specialization
//=----------------------------------------------------------------------------=

extension NumericTextSchemeXCurrency {
    
    //=------------------------------------------------------------------------=
    // MARK: Preferences
    //=------------------------------------------------------------------------=
    
    @inlinable func precision<T>(_ value: T.Type) -> Precision<T> where T: Value {
        Precision(fraction: defaults.fractionLimits)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ snapshot: inout Snapshot) {
        guard !label.characters.isEmpty else { return }
        guard let indices = label.indices(in: snapshot) else { return }
        snapshot.update(attributes: indices) { attribute in attribute = .phantom }
    }
}
