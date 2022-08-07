//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Traits x Standard
//*============================================================================*

public protocol _Standard {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var locale: Locale { get set }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale)
}

//*============================================================================*
// MARK: * Traits x Currency
//*============================================================================*

public protocol _Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var locale: Locale { get set }
    
    @inlinable var currencyCode: String { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(code: String, locale: Locale)
}

//*============================================================================*
// MARK: * Traits x Measurement
//*============================================================================*

public protocol _Measurement {
    
    associatedtype Unit: Dimension
    
    typealias Width = Measurement<Unit>.FormatStyle.UnitWidth
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var unit: Unit { get set }
    
    @inlinable var width: Width { get set }
    
    @inlinable var locale: Locale  { get set }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unit: Unit, width: Width, locale: Locale)
}

//=----------------------------------------------------------------------------=
// MARK: + Style
//=----------------------------------------------------------------------------=

public extension DiffableTextStyle where Self: _Measurement {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func unit(_ unit: Unit) -> Self {
        var S0 = self; S0.unit = unit; return S0
    }
    
    @inlinable func width(_ width: Width) -> Self {
        var S0 = self; S0.width  = width; return S0
    }
}
