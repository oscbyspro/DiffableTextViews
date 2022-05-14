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
    
    var count: Int {
        format.storage == .currency ? 2 : 1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        foundation.hidden().overlay(wheels).pickerStyle(.wheel)
    }
    
    var foundation: some View {
        Picker("", selection: .constant(false)) { }
    }
    
    var wheels: some View {
        GeometryReader {
            let sized = Sized($0, count: count)
            
            HStack(spacing: 0) {
                //=------------------------------=
                // Locales
                //=------------------------------=
                locales.modifier(sized).zIndex(1)
                //=------------------------------=
                // Currencies
                //=------------------------------=
                if format.storage == .currency {
                    Divider()
                    currencies.modifier(sized)
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var locales: some View {
        Selector(Constants.locales, selection: locale.xstorage, id: \.identifier)
    }
    
    var currencies: some View {
        Selector(Constants.currencies, selection: currency.xstorage, id: \.self)
    }
    
    //*========================================================================*
    // MARK: Declaration
    //*========================================================================*
    
    struct Sized: ViewModifier {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        let width: CGFloat
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=

        init(_ proxy: GeometryProxy, count: Int) {
            self.width = proxy.size.width / CGFloat(count)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Body
        //=--------------------------------------------------------------------=
        
        func body(content: Content) -> some View {
            content.frame(width: width).clipped()
        }
    }
}
