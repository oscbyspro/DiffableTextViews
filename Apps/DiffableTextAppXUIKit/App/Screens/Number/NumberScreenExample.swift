//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import SwiftUI

//*============================================================================*
// MARK: * Screen x Number x Example
//*============================================================================*

struct NumberScreenExample: View {
    typealias Context = NumberScreenContext
    typealias KindID = Context.KindID
    typealias FormatID = Context.FormatID
    typealias PrecisionID = Context.PrecisionID
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let context: Context
    
    @ObservedObject var kind: Observable<KindID>
    @ObservedObject var format: Observable<FormatID>
    @ObservedObject var locale: Observable<Locale>
    @ObservedObject var currency: Observable<String>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ context: Context) {
        self.context = context
        self.kind = context.$kind
        self.format = context.$format
        self.locale = context.$locale
        self.currency = context.$currency
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        switch (kind.value, format.value) {
        
        case (.standard,   .number): decimalStandardNumber
        case (.standard, .currency): decimalStandardCurrency
        case (.standard,  .percent): decimalStandardPercent
        
        case (.optional,   .number): decimalOptionalNumber
        case (.optional, .currency): decimalOptionalCurrency
        case (.optional,  .percent): decimalOptionalPercent }
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
// MARK: * Screen x Number x Example X
//*============================================================================*

struct NumberScreenExampleX<Style>: View where Style: _Style,
Style.Value: _Value, Style.Input == Decimal {
    typealias Context = NumberScreenContext
    typealias Member  = Source.KeyPath<Style.Value>
    typealias Source  = Observable<Twins<Style.Input>>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
        
    let base:   Style
    let source: Source
    let member: Member
    
    @ObservedObject var bounds:    Observable<Bounds>
    @ObservedObject var digits:    Observable<(Int, Int)>
    @ObservedObject var integer:   Observable<(Int, Int)>
    @ObservedObject var fraction:  Observable<(Int, Int)>
    @ObservedObject var precision: Observable<Context.PrecisionID>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    init(_ context: Context, _ source: Source, _ member: Member, _ base: Style) {
        self.base   = base
        self.source = source
        self.member = member
                
        self.bounds    = context.$bounds
        self.digits    = context.$digits
        self.integer   = context.$integer
        self.fraction  = context.$fraction
        self.precision = context.$precision
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    var body: some View {
        Observer(source, cache: style) {
            Example(value: $0[dynamicMember: member], style: $1)
        }
        .diffableTextViews_keyboardType(.decimalPad)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var style: some DiffableTextStyle<Style.Value> {
        //=--------------------------------------=
        // Bounds
        //=--------------------------------------=
        var style = base.bounds(bounds.value.closed)
        //=--------------------------------------=
        // Precision
        //=--------------------------------------=
        switch precision.value {
        case .sides: style = style.precision(
        integer:  ClosedRange(integer .value),
        fraction: ClosedRange(fraction.value))
        case .total: style = style.precision(ClosedRange(digits.value)) }
        //=--------------------------------------=
        // Constant
        //=--------------------------------------=
        return style.constant()
    }
}
