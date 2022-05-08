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
struct NumberScreenExample: View {
    typealias Context = NumberScreenContext
    typealias FormatID = Context.FormatID
    typealias OptionalityID = Context.OptionalityID

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let context: Context
    
    @ObservedObject var locale: Observable<Locale>
    @ObservedObject var currency: Observable<String>
    @ObservedObject var format: Observable<FormatID>
    @ObservedObject var optionality: Observable<OptionalityID>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init( _ context: Context) {
        self.context = context
        self.locale = context.locale
        self.currency = context.currency
        self.format = context.format
        self.optionality = context.optionality
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        switch (optionality.wrapped, format.wrapped) {
        case (.standard,    .number): decimalStandardNumberView
        case (.standard,  .currency): decimalStandardCurrencyView
        case (.standard,   .percent): decimalStandardPercentView
        case (.optional,   .number): decimalOptionalNumberView
        case (.optional, .currency): decimalOptionalCurrencyView
        case (.optional,  .percent): decimalOptionalPercentView
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Standard
    //=------------------------------------------------------------------------=
    
    var decimalStandardNumberView: some View {
        NumberScreenExampleX(context, context.decimals.xstandard,
        NumberTextStyle<Decimal>(locale: locale.wrapped))
    }
    
    var decimalStandardCurrencyView: some View {
        NumberScreenExampleX(context, context.decimals.xstandard,
        NumberTextStyle<Decimal>.Currency(code: currency.wrapped, locale: locale.wrapped))
    }
    
    var decimalStandardPercentView: some View {
        NumberScreenExampleX(context, context.decimals.xstandard,
        NumberTextStyle<Decimal>.Percent(locale: locale.wrapped))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Optional
    //=------------------------------------------------------------------------=
 
    var decimalOptionalNumberView: some View {
        NumberScreenExampleX(context, context.decimals.xoptional,
        NumberTextStyle<Decimal?>(locale: locale.wrapped))
    }
    
    var decimalOptionalCurrencyView: some View {
        NumberScreenExampleX(context, context.decimals.xoptional,
        NumberTextStyle<Decimal?>.Currency(code: currency.wrapped, locale: locale.wrapped))
    }
    
    var decimalOptionalPercentView: some View {
        NumberScreenExampleX(context, context.decimals.xoptional,
        NumberTextStyle<Decimal?>.Percent(locale: locale.wrapped))
    }
}

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct NumberScreenExampleX<Style: NumberTextStyleProtocol>: View
where Style.Format.FormatInput == Decimal {
    typealias Value = Style.Value
    typealias Context = NumberScreenContext
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    let base: Style
    let context: Context
    let value: Binding<Value>

    @ObservedObject var bounds: ObservableIntegerIntervalAsBounds<Decimal>
    @ObservedObject var integer: Observable<Interval<Int>>
    @ObservedObject var fraction: Observable<Interval<Int>>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    init(_ context: NumberScreenContext, _ value: Binding<Value>, _ base: Style) {
        self.base = base
        self.value = value
        self.context = context
        self.bounds = context.bounds
        self.integer = context.integer
        self.fraction = context.fraction
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    var style: Style {
        base.bounds(bounds.values).precision(
        integer:  integer .wrapped.closed,
        fraction: fraction.wrapped.closed)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=

    var body: some View {
        NumberScreenExampleY(context, value: value, style: style.constant())
    }
}

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct NumberScreenExampleY<Style: DiffableTextStyle>: View {
    typealias Value = Style.Value
    typealias Context = NumberScreenContext
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    let style: Style
    let value: Binding<Value>
    @ObservedObject var values: ObservableTwinValues<Decimal>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ context: Context, value: Binding<Value>, style: Style) {
        self.value = value; self.style = style; self.values = context.decimals
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Example(value, style: style)
    }
}
