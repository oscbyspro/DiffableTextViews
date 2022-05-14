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
        self.locale = context.$locale
        self.currency = context.$currency
        self.format = context.$format
        self.optionality = context.$optionality
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        switch (optionality.storage, format.storage) {
        case (.standard,   .number): decimalStandardNumber
        case (.standard, .currency): decimalStandardCurrency
        case (.standard,  .percent): decimalStandardPercent
        case (.optional,   .number): decimalOptionalNumber
        case (.optional, .currency): decimalOptionalCurrency
        case (.optional,  .percent): decimalOptionalPercent
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Standard
    //=------------------------------------------------------------------------=
    
    var decimalStandardNumber: some View {
        NumberScreenExampleX(context, context.$decimals, \.standard,
        NumberTextStyle<Decimal>(locale: locale.storage))
    }
    
    var decimalStandardCurrency: some View {
        NumberScreenExampleX(context, context.$decimals, \.standard,
        NumberTextStyle<Decimal>.Currency(code: currency.storage, locale: locale.storage))
    }
    
    var decimalStandardPercent: some View {
        NumberScreenExampleX(context, context.$decimals, \.standard,
        NumberTextStyle<Decimal>.Percent(locale: locale.storage))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Optional
    //=------------------------------------------------------------------------=
 
    var decimalOptionalNumber: some View {
        NumberScreenExampleX(context, context.$decimals, \.optional,
        NumberTextStyle<Decimal?>(locale: locale.storage))
    }
    
    var decimalOptionalCurrency: some View {
        NumberScreenExampleX(context, context.$decimals, \.optional,
        NumberTextStyle<Decimal?>.Currency(code: currency.storage, locale: locale.storage))
    }
    
    var decimalOptionalPercent: some View {
        NumberScreenExampleX(context, context.$decimals, \.optional,
        NumberTextStyle<Decimal?>.Percent(locale: locale.storage))
    }
}

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct NumberScreenExampleX<Style>: View
where Style: NumberTextStyleProtocol,
Style.Format.FormatInput == Decimal {
    typealias Value  = Style.Value
    typealias Source = Observable<Twins<Decimal>>
    typealias Target = Source.Subbinding<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    let base:   Style
    let source: Source
    let target: Target

    @ObservedObject var bounds: Observable<Bounds>
    @ObservedObject var integer: Observable<Interval<Int>>
    @ObservedObject var fraction: Observable<Interval<Int>>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    init(_ context: NumberScreenContext, _ source: Source, _ target: Target, _ base: Style) {
        self.base = base; self.source = source; self.target = target
        self.bounds = context.$bounds; self.integer = context.$integer
        self.fraction = context.$fraction
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    var style: Style.Constant {
        base.bounds(bounds.storage.values).precision(
        integer:  integer .storage.closed,
        fraction: fraction.storage.closed).constant()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=

    var body: some View {
        Observer(source, cache: style) { source, style in
            Example(value: source[keyPath: target], style: style)
        }
        .diffableTextViews_keyboardType(Value.isInteger ? .numberPad : .decimalPad)
    }
}
