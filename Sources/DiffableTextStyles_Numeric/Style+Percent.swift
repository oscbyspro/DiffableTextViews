//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * Style x Percent
//*============================================================================*

extension NumericTextStyle where Format: NumericTextFormat_Percent {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(locale: Locale =  .autoupdatingCurrent) {
        self.init(Format(locale: locale))
    }
}

//*============================================================================*
// MARK: * Decimal
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Decimal>.Percent {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var percent: Self {
        Self()
    }
}

//*============================================================================*
// MARK: * Double
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Double>.Percent {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var percent: Self {
        Self()
    }
}
