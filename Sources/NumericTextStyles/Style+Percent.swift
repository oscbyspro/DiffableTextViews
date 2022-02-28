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
// MARK: * Float16
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Float16>.Percent {
    //=------------------------------------------=
    // MARK: Internal - Inaccurate Format Style
    //=------------------------------------------=
    @inlinable internal static var percent: Self {
        Self(.percent)
    }
}

//*============================================================================*
// MARK: * Float32
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Float32>.Percent {
    //=------------------------------------------=
    // MARK: Internal - Inaccurate Format Style
    //=------------------------------------------=
    @inlinable internal static var percent: Self {
        Self(.percent)
    }
}

//*============================================================================*
// MARK: * Float64
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Float64>.Percent {
    @inlinable public static var percent: Self {
        Self(.percent)
    }
}
