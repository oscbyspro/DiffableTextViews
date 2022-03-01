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
// MARK: * Style x Initializers
//*============================================================================*

extension NumericTextStyle where Format: NumericTextFormat_Currency {
    @inlinable public init(code: String, locale: Locale = .autoupdatingCurrent) {
        self.init(Format(code: code, locale: locale))
    }
}

//*============================================================================*
// MARK: * Decimal
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Decimal>.Currency {
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * Double
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Double>.Currency {
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * Ints
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Int>.Currency {
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * Int8
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Int8>.Currency {
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * Int16
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Int16>.Currency {
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * Int32
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Int32>.Currency {
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * Int64
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<Int64>.Currency {
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * UInts
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<UInt>.Currency {
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * UInt8
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<UInt8>.Currency {
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * UInt16
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<UInt16>.Currency {
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * UInt32
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<UInt32>.Currency {
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: * UInt64
//*============================================================================*

extension DiffableTextStyle where Self == NumericTextStyle<UInt64>.Currency {
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}
