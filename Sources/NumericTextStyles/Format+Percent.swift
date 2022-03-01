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

extension Decimal.FormatStyle.Percent: Format, Formats.Percent {
    
    //=------------------------------------------------------------------------=
    // MARK: Translations
    //=------------------------------------------------------------------------=
    
    @inlinable public func translation() -> some NumericTextTranslation {
        Translations.Standard.reuseable(self)
    }
}

//*============================================================================*
// MARK: * Floating Point
//*============================================================================*

extension FloatingPointFormatStyle.Percent: Format, Formats.Percent where Value: NumericTextValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Translations
    //=------------------------------------------------------------------------=
    
    @inlinable public func translation() -> some NumericTextTranslation {
        Translations.Standard.reuseable(self)
    }
}
