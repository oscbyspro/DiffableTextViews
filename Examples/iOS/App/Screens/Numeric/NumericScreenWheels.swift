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
// MARK: * NumericScreenWheels
//*============================================================================*

struct NumericScreenWheels: View {
    typealias Style = NumericScreen.Style
    
    //=------------------------------------------------------------------------=
    // MARK: Environment
    //=------------------------------------------------------------------------=
    
    @EnvironmentObject private var context: Context
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    let style: Style
    let locale: Binding<Locale>
    let currency: Binding<String>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ style: Style, locale: Binding<Locale>, currency: Binding<String>) {
        self.style = style
        self.locale = locale
        self.currency = currency
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        foundation.hidden().overlay(wheels)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    var foundation: some View {
        Picker(String(), selection: .constant(false)) { }.pickerStyle(.wheel)
    }
    
    var wheels: some View {
        GeometryReader {
            let separate = Separate($0, style: style)
            //=----------------------------------=
            // MARK: Content
            //=----------------------------------=
            HStack(spacing: 0) {
                locales.modifier(separate).zIndex(1)
                if style == .currency {
                    Divider()
                    currencies.modifier(separate)
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Subcomponents
    //=------------------------------------------------------------------------=
    
    var locales: some View {
        Selector(context.locales, selection: locale, id: \.identifier)
    }
    
    var currencies: some View {
        Selector(context.currencies, selection: currency, id: \.self)
    }
    
    //*========================================================================*
    // MARK: * Separate
    //*========================================================================*
    
    struct Separate: ViewModifier {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        let width: CGFloat
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=

        init(_ proxy: GeometryProxy, style: Style) {
            self.width = proxy.size.width / CGFloat(style == .currency ? 2 : 1)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Body
        //=--------------------------------------------------------------------=
        
        func body(content: Content) -> some View {
            content.frame(width: width).clipped()
        }
    }
}
