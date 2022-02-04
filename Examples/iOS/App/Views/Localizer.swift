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
// MARK: * Localizer
//*============================================================================*

struct Localizer: View {
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    static let locales: [Locale] = Locale
        .availableIdentifiers.map(Locale.init)
        .reduce(into: Set()) { $0.insert($1) }
        .sorted(by: { $0.identifier < $1.identifier })
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let selection: Binding<Locale>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ selection: Binding<Locale>) { self.selection = selection }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Picker("Locales", selection: selection) {
            ForEach(Self.locales, id: \.self) { locale in
                Text(String(describing: locale)).tag(locale)
            }
        }
        .pickerStyle(.wheel)
    }
}

