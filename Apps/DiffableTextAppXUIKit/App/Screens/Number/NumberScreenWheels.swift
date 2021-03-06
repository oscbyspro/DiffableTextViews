//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI

//*============================================================================*
// MARK: * Screen x Number x Wheels
//*============================================================================*

struct NumberScreenWheels: View {
    typealias Context = NumberScreenContext
    typealias FormatID = Context.FormatID
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @ObservedObject var format:   Observable<FormatID>
    @ObservedObject var locale:   Observable<Locale>
    @ObservedObject var currency: Observable<String>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ context: Context) {
        self.format = context.$format
        self.locale = context.$locale
        self.currency = context.$currency
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    func size(_ proxy: GeometryProxy) -> Size {
        Size(width: proxy.size.width / CGFloat(format == .currency ? 2 : 1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        foundation.hidden().overlay(pickers).pickerStyle(.wheel)
    }
    
    var foundation: some View {
        Picker("", selection: .constant(0)) { }
    }
    
    var pickers: some View {
        GeometryReader {
            let size = size($0)
            HStack(spacing: 00) {
                //=------------------------------=
                // Locales
                //=------------------------------=
                locales.modifier(size).zIndex(1)
                //=------------------------------=
                // Currencies
                //=------------------------------=
                if format == .currency {
                    Divider()
                    currencies.modifier(size)
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var locales: some View {
        Selector(Constants.locales, selection: $locale.value, label: \.identifier)
    }
    
    var currencies: some View {
        Selector(Constants.currencies, selection: $currency.value, label: { $0 })
    }
    
    //*========================================================================*
    // MARK: * Size
    //*========================================================================*
    
    struct Size: ViewModifier {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        let width: CGFloat
        
        //=--------------------------------------------------------------------=
        // MARK: Body
        //=--------------------------------------------------------------------=
        
        func body(content: Content) -> some View {
            content.frame(width: width).clipped()
        }
    }
}
