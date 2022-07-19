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
// MARK: * Default x Currency
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Decimal>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

//=----------------------------------------------------------------------------=
// MARK: + Float(s)
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Double>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

//=----------------------------------------------------------------------------=
// MARK: + Int(s)
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Int>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int8>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int16>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int32>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int64>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

//=----------------------------------------------------------------------------=
// MARK: + UInt(s)
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<UInt>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt8>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt16>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt32>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt64>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}
