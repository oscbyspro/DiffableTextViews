//
//  DiffableTextStyles.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import DiffableTextViews
import struct Foundation.Decimal

// MARK: - UInts

public extension DiffableTextStyle where Self == NumberTextStyle<UInt> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumberTextStyle<UInt8> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumberTextStyle<UInt16> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumberTextStyle<UInt32> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumberTextStyle<UInt64> {
    @inlinable static var number: Self { .init() }
}

// MARK: - Ints

public extension DiffableTextStyle where Self == NumberTextStyle<Int> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumberTextStyle<Int8> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumberTextStyle<Int16> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumberTextStyle<Int32> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumberTextStyle<Int64> {
    @inlinable static var number: Self { .init() }
}

// MARK: - Floats

public extension DiffableTextStyle where Self == NumberTextStyle<Float16> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumberTextStyle<Float32> {
    @inlinable static var number: Self { .init() }
}

public extension DiffableTextStyle where Self == NumberTextStyle<Float64> {
    @inlinable static var number: Self { .init() }
}

// MARK: - Decimals

public extension DiffableTextStyle where Self == NumberTextStyle<Decimal> {
    @inlinable static var number: Self { .init() }
}
