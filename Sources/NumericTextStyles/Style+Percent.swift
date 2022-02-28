//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import Foundation

//*============================================================================*
// MARK: * Decimal
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Decimal>.Percent {
    @inlinable public static var percent: Self {
        Self(.percent)
    }
}

//*============================================================================*
// MARK: * Double
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Double>.Percent {
    @inlinable public static var percent: Self {
        Self(.percent)
    }
}
