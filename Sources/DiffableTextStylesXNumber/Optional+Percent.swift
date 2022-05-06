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
// MARK: Percent
//*============================================================================*

extension _OptionalNumberTextStyle where Format: NumberTextFormatXPercent {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(locale: Locale =  .autoupdatingCurrent) {
        self.init(Format(locale: locale))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Decimal
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Decimal?>.Percent {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var percent: Self {
        Self()
    }
}

//=----------------------------------------------------------------------------=
// MARK: Double
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Double?>.Percent {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var percent: Self {
        Self()
    }
}
