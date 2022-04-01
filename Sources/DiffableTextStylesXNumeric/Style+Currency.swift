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
// MARK: * Style x Currency
//*============================================================================*

extension NumericTextStyle where Format: NumericTextFormatXCurrency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(code: String, locale: Locale = .autoupdatingCurrent) {
        self.init(Format(code: code, locale: locale))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var currencyCode: String {
        format.currencyCode
    }
}

//*============================================================================*
// MARK: * Decimal
//*============================================================================*

extension _DiffableTextStyle where Self == NumericTextStyle<Decimal>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * Double
//*============================================================================*

extension _DiffableTextStyle where Self == NumericTextStyle<Double>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * Int
//*============================================================================*

extension _DiffableTextStyle where Self == NumericTextStyle<Int>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * Int8
//*============================================================================*

extension _DiffableTextStyle where Self == NumericTextStyle<Int8>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * Int16
//*============================================================================*

extension _DiffableTextStyle where Self == NumericTextStyle<Int16>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * Int32
//*============================================================================*

extension _DiffableTextStyle where Self == NumericTextStyle<Int32>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * Int64
//*============================================================================*

extension _DiffableTextStyle where Self == NumericTextStyle<Int64>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * UInt
//*============================================================================*

extension _DiffableTextStyle where Self == NumericTextStyle<UInt>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * UInt8
//*============================================================================*

extension _DiffableTextStyle where Self == NumericTextStyle<UInt8>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * UInt16
//*============================================================================*

extension _DiffableTextStyle where Self == NumericTextStyle<UInt16>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * UInt32
//*============================================================================*

extension _DiffableTextStyle where Self == NumericTextStyle<UInt32>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * UInt64
//*============================================================================*

extension _DiffableTextStyle where Self == NumericTextStyle<UInt64>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}
