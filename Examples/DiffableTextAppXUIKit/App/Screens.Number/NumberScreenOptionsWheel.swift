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
// MARK: Declaration
//*============================================================================*

struct NumberScreenOptionsWheel: View {
    typealias Context = NumberScreenContext
    typealias FormatID = Context.FormatID
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @ObservedObject var format: Observable<FormatID>
    @ObservedObject var locale: Observable<Locale>
    @ObservedObject var currency: Observable<String>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ context: Context) {
        self.format = context.format
        self.locale = context.locale
        self.currency = context.currency
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        foundation.hidden().overlay(wheels)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=

    var foundation: some View {
        Picker(String(), selection: .constant(false)) { }.pickerStyle(.wheel)
    }
    
    var wheels: some View {
        GeometryReader {
            let separate = Separate($0, kind: format.wrapped)
            //=----------------------------------=
            // Content
            //=----------------------------------=
            HStack(spacing: 0) {
                locales.modifier(separate).zIndex(1)
                if format.wrapped == .currency {
                    Divider()
                    currencies.modifier(separate)
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var locales: some View {
        Wheel(Constants.locales, selection: locale.xwrapped, id: \.identifier)
    }
    
    var currencies: some View {
        Wheel(Constants.currencies, selection: currency.xwrapped, id: \.self)
    }
    
    //*========================================================================*
    // MARK: Separate
    //*========================================================================*
    
    struct Separate: ViewModifier {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        let width: CGFloat
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=

        init(_ proxy: GeometryProxy, kind: FormatID) {
            self.width = proxy.size.width / CGFloat(kind == .currency ? 2 : 1)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Body
        //=--------------------------------------------------------------------=
        
        func body(content: Content) -> some View {
            content.frame(width: width).clipped()
        }
    }
}
