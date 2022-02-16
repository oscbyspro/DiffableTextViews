//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import Foundation
@testable import NumericTextStyles

//*============================================================================*
// MARK: * Earth
//*============================================================================*

enum Earth {

    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    static let locales: [Locale] = Locale
        .availableIdentifiers.lazy.map(Locale.init)
        .sorted(by: { $0.identifier < $1.identifier })
    
    static let regions: [Region] = locales
        .compactMap({ try? Region($0) })
    
    static let currencies: [String] = locales
        .lazy.compactMap(\.currencyCode)
        .reduce(into: Set()) { $0.insert($1) }
        .map({ $0 }).sorted(by: <)
}

//*============================================================================*
// MARK: * Earthly
//*============================================================================*

protocol Earthly { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension Earthly {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var earth: Earth.Type {
        Earth.self
    }
    
    var locales: [Locale] {
        earth.locales
    }
    
    var regions: [Region] {
        earth.regions
    }
    
    var currencies: [String] {
        earth.currencies
    }
}

#endif
