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
// MARK: * Format x Percent
//*============================================================================*
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension Decimal.FormatStyle.Percent:
NumberTextFormat,
NumberTextFormatXPercent {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable public func scheme() -> some NumberTextScheme {
        NumberTextSchemeXStandard.reuse(self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Floating Point
//=----------------------------------------------------------------------------=

extension FloatingPointFormatStyle.Percent:
NumberTextFormat,
NumberTextFormatXPercent
where Value: NumberTextValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func scheme() -> some NumberTextScheme {
        NumberTextSchemeXStandard.reuse(self)
    }
}
