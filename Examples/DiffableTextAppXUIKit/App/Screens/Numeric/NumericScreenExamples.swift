//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI
import DiffableTextViews

//*============================================================================*
// MARK: Declaration
//*============================================================================*

/// An intermediate examples view that observes infrequent changes.
struct NumericScreenExamples: View {
    typealias Context = NumericScreenContext
    typealias Kind = Context.Kind
    typealias Value = Context.Value
    typealias Number = Value.FormatStyle
    typealias Currency = Number.Currency
    typealias Percent = Number.Percent

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let context: Context
    @ObservedObject var kind: Source<Kind>
    @ObservedObject var currency: Source<String>
    @ObservedObject var locale: Source<Locale>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ context: Context) {
        self.context = context
        self.kind = context.kind
        self.currency = context.currency
        self.locale = context.locale
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Group {
            switch kind.content {
            case   .number:   numberExample
            case .currency: currencyExample
            case  .percent:  percentExample
            }
        }
        .environment(\.locale, locale.content)
    }
    
    @inlinable var currencyExample: some View {
        NumericScreenExample(context,
        base: _NumberTextStyle<Currency>(
        code: currency.content, locale: locale.content))
    }
    
    @inlinable var numberExample: some View {
        NumericScreenExample(context,
        base: _NumberTextStyle<Number>(
        locale: locale.content))
    }
    
    @inlinable var percentExample: some View {
        NumericScreenExample(context,
        base: _NumberTextStyle<Percent>(
        locale: locale.content))
    }
}
