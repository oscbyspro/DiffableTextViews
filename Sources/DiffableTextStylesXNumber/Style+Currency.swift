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
// MARK: Currency
//*============================================================================*

extension NumberTextStyle where Format: NumberTextFormatXCurrency {
    
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
        self.format.currencyCode
    }
}

//*============================================================================*
// MARK: Decimal
//*============================================================================*

extension DiffableTextStyle where Self == NumberTextStyle<Decimal>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: Double
//*============================================================================*

extension DiffableTextStyle where Self == NumberTextStyle<Double>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: Int
//*============================================================================*

extension DiffableTextStyle where Self == NumberTextStyle<Int>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: Int8
//*============================================================================*

extension DiffableTextStyle where Self == NumberTextStyle<Int8>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: Int16
//*============================================================================*

extension DiffableTextStyle where Self == NumberTextStyle<Int16>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: Int32
//*============================================================================*

extension DiffableTextStyle where Self == NumberTextStyle<Int32>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: Int64
//*============================================================================*

extension DiffableTextStyle where Self == NumberTextStyle<Int64>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: UInt
//*============================================================================*

extension DiffableTextStyle where Self == NumberTextStyle<UInt>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: UInt8
//*============================================================================*

extension DiffableTextStyle where Self == NumberTextStyle<UInt8>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: UInt16
//*============================================================================*

extension DiffableTextStyle where Self == NumberTextStyle<UInt16>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: UInt32
//*============================================================================*

extension DiffableTextStyle where Self == NumberTextStyle<UInt32>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}

//*============================================================================*
// MARK: UInt64
//*============================================================================*

extension DiffableTextStyle where Self == NumberTextStyle<UInt64>.Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func currency(code: String) -> Self {
        Self(code: code)
    }
}
