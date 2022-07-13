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
// MARK: * Cache x Currency
//*============================================================================*

public struct _Cache_Currency<Format>: _Cache_Internal_Base where Format: _Format_Currency {    
    public typealias Style = _Style_Currency<Format>
    public typealias Value = Format.FormatInput
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var style: Style
    @usableFromInline let interpreter: NumberTextReader
    @usableFromInline let preferences: Preferences<Value>
    @usableFromInline let adjustments: Adjustments?

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ style: Style) {
        self.style = style
        //=--------------------------------------=
        // Formatter
        //=--------------------------------------=
        let formatter = NumberFormatter()
        formatter.locale = style.locale
        formatter.currencyCode = style.currencyCode
        //=--------------------------------------=
        // Formatter x None
        //=--------------------------------------=
        assert(formatter.numberStyle == .none)
        self.interpreter = .currency(formatter)
        //=--------------------------------------=
        // Formatter x Currency
        //=--------------------------------------=
        formatter.numberStyle = .currency
        self.preferences = .currency(formatter)
        //=--------------------------------------=
        // Formatter x Currency x Fractionless
        //=--------------------------------------=
        formatter.maximumFractionDigits = .zero
        self.adjustments = Adjustments(formatter, interpreter.components)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        var snapshot = Snapshot(characters, as: interpreter.attributes.map)
        adjustments?.autocorrect(&snapshot)
        return snapshot
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
            separator: components.digits[.zero], omittingEmptySubsequences: false)
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
