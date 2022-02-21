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
// MARK: * Decimal
//*============================================================================*

extension Decimal.FormatStyle.Percent: Formats.Percent {
    @inlinable public func translation() -> some NumericTextTranslation {
        NumericTextStyles.Standard.cache(self)
    }
}

//*============================================================================*
// MARK: * Float
//*============================================================================*

extension FloatingPointFormatStyle.Percent: Format, Formats.Percent where FormatInput: NumericTextFloatValue {
    @inlinable public func translation() -> some NumericTextTranslation {
        NumericTextStyles.Standard.cache(self)
    }
}
