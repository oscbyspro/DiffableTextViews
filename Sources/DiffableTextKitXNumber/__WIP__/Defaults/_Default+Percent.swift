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
// MARK: * Default x Percent
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == _WIP_NumberTextStyle<Decimal>.Percent {
    @inlinable public static var percent: Self { Self() }
}

//=----------------------------------------------------------------------------=
// MARK: + Float(s)
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == _WIP_NumberTextStyle<Double>.Percent {
    @inlinable public static var percent: Self { Self() }
}
