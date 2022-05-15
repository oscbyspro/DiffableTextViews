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
        switch (optionality.value, format.value) {
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
        NumberScreenExampleX(context,
        context.$decimals, \.value.standard,
        NumberTextStyle<Decimal>(locale: locale.value))
    }
    
    var decimalStandardCurrency: some View {
        NumberScreenExampleX(context,
        context.$decimals, \.value.standard,
        NumberTextStyle<Decimal>.Currency(
        code: currency.value, locale: locale.value))
    }
    
    var decimalStandardPercent: some View {
        NumberScreenExampleX(context,
        context.$decimals, \.value.standard,
        NumberTextStyle<Decimal>.Percent(locale: locale.value))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Optional
    //=------------------------------------------------------------------------=
 
    var decimalOptionalNumber: some View {
        NumberScreenExampleX(context,
        context.$decimals, \.value.optional,
        NumberTextStyle<Decimal?>(locale: locale.value))
    }
    
    var decimalOptionalCurrency: some View {
        NumberScreenExampleX(context,
        context.$decimals, \.value.optional,
        NumberTextStyle<Decimal?>.Currency(
        code: currency.value, locale: locale.value))
    }
    
    var decimalOptionalPercent: some View {
        NumberScreenExampleX(context,
        context.$decimals, \.value.optional,
        NumberTextStyle<Decimal?>.Percent(locale: locale.value))
    }
}

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct NumberScreenExampleX<Style>: View
where Style: NumberTextStyleProtocol,
Style.Format.FormatInput == Decimal {
    typealias Value = Style.Value
    typealias Input = Style.Format.FormatInput
    typealias Source = Observable<Twins<Input>>
    typealias Target = Source.KeyPath<Value>
    typealias Context = NumberScreenContext
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let style:  Style
    let source: Source
    let target: Target

    @ObservedObject var bounds:   Observable<Bounds>
    @ObservedObject var integer:  Observable<(Int, Int)>
    @ObservedObject var fraction: Observable<(Int, Int)>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    init(_ context: Context, _ source: Source, _ target: Target, _ style: Style) {
        self.style  = style
        self.source = source
        self.target = target
        
        self.bounds   = context.$bounds
        self.integer  = context.$integer
        self.fraction = context.$fraction
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    var xbounds: NumberTextBounds<Input> {
        NumberTextBounds(bounds.value.closed)
    }
    
    var xprecision: NumberTextPrecision<Input> {
        let integer  = ClosedRange(integer .value)
        let fraction = ClosedRange(fraction.value)
        return NumberTextPrecision(integer: integer, fraction: fraction)
    }
    
    var xstyle: Style.Constant {
        style.bounds(xbounds).precision(xprecision).constant()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=

    var body: some View {
        Observer(source, cache: xstyle) {
            Example(value: $0[dynamicMember: target], style: $1)
        }
        .diffableTextViews_keyboardType(Value.isInteger ? .numberPad : .decimalPad)
    }
}
