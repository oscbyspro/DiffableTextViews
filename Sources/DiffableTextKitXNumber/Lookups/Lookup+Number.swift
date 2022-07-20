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
// MARK: * Lookup x Number
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Decimal> {
    @inlinable public static var number: Self { Self() }
}

//=----------------------------------------------------------------------------=
// MARK: + Float(s)
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Double> {
    @inlinable public static var number: Self { Self() }
}

//=----------------------------------------------------------------------------=
// MARK: + Int(s)
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Int> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int8> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int16> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int32> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int64> {
    @inlinable public static var number: Self { Self() }
}

//=----------------------------------------------------------------------------=
// MARK: + UInt(s)
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<UInt> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt8> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt16> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt32> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt64> {
    @inlinable public static var number: Self { Self() }
}

//*============================================================================*
// MARK: * Lookup x Number x Optional
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Decimal?> {
    @inlinable public static var number: Self { Self() }
}

//=----------------------------------------------------------------------------=
// MARK: + Float(s)
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Double?> {
    @inlinable public static var number: Self { Self() }
}

//=----------------------------------------------------------------------------=
// MARK: + Int(s)
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Int?> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int8?> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int16?> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int32?> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int64?> {
    @inlinable public static var number: Self { Self() }
}

//=----------------------------------------------------------------------------=
// MARK: + UInt(s)
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<UInt?> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt8?> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt16?> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt32?> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt64?> {
    @inlinable public static var number: Self { Self() }
}
