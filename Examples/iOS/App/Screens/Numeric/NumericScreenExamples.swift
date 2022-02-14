//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI
import NumericTextStyles

//*============================================================================*
// MARK: * NumericScreenExamples
//*============================================================================*

/// An intermediate examples view that observes infrequent changes.
struct NumericScreenExamples: View {
    typealias Kind = NumericScreenContext.Kind
    typealias Number = Decimal.FormatStyle
    typealias Currency = Number.Currency
    typealias Percent = Number.Percent

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let context: NumericScreenContext
    @ObservedObject var kind: Source<Kind>
    @ObservedObject var currency: Source<String>
    @ObservedObject var locale: Source<Locale>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ context: NumericScreenContext) {
        self.context = context
        self.kind = context.kind
        self.currency = context.currency
        self.locale = context.locale
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        examples.environment(\.locale, locale.value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    @ViewBuilder var examples: some View {
        switch kind.value {
        case .number: NumericScreenExample<Number>(context, base: .number)
        case .currency: NumericScreenExample<Currency>(context, base: .currency(code: currency.value))
        case .percent: NumericScreenExample<Percent>(context, base: .percent)
        }
    }
}
