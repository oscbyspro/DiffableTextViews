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
    typealias Context = NumericScreenContext
    typealias Kind = Context.Kind
    
    //=------------------------------------------------------------------------=
    // MARK: Environment
    //=------------------------------------------------------------------------=
    
    @EnvironmentObject var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @ObservedObject var kind: Source<Kind>
    @ObservedObject var locale: Source<Locale>
    @ObservedObject var currency: Source<String>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ context: Context) {
        self.kind = context.kind
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
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    var foundation: some View {
        Picker(String(), selection: .constant(false)) { }.pickerStyle(.wheel)
    }
    
    var wheels: some View {
        GeometryReader {
            let separate = Separate($0, kind: kind.storage)
            //=----------------------------------=
            // MARK: Content
            //=----------------------------------=
            HStack(spacing: 0) {
                locales.modifier(separate).zIndex(1)
                if kind.storage == .currency {
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
        Wheel(storage.locales, selection: locale.binding, id: \.identifier)
    }
    
    var currencies: some View {
        Wheel(storage.currencies, selection: currency.binding, id: \.self)
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

        init(_ proxy: GeometryProxy, kind: Kind) {
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
