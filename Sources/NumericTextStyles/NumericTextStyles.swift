//
//  NumericTextStyles.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import DiffableTextViews
import struct Foundation.Decimal

// MARK: - UInts

extension NumericTextStyle where Value == UInt {
    @usableFromInline static let standard = Self()
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt> {
    @inlinable static var number: Self { .standard }
}

extension NumericTextStyle where Value == UInt8 {
    @usableFromInline static let standard = Self()
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt8> {
    @inlinable static var number: Self { .standard }
}

extension NumericTextStyle where Value == UInt16 {
    @usableFromInline static let standard = Self()
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt16> {
    @inlinable static var number: Self { .standard }
}

extension NumericTextStyle where Value == UInt32 {
    @usableFromInline static let standard = Self()
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt32> {
    @inlinable static var number: Self { .standard }
}

extension NumericTextStyle where Value == UInt64 {
    @usableFromInline static let standard = Self()
}

public extension DiffableTextStyle where Self == NumericTextStyle<UInt64> {
    @inlinable static var number: Self { .standard }
}

// MARK: - Ints

extension NumericTextStyle where Value == Int {
    @usableFromInline static let standard = Self()
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int> {
    @inlinable static var number: Self { .standard }
}

extension NumericTextStyle where Value == Int8 {
    @usableFromInline static let standard = Self()
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int8> {
    @inlinable static var number: Self { .standard }
}

extension NumericTextStyle where Value == Int16 {
    @usableFromInline static let standard = Self()
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int16> {
    @inlinable static var number: Self { .standard }
}

extension NumericTextStyle where Value == Int32 {
    @usableFromInline static let standard = Self()
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int32> {
    @inlinable static var number: Self { .standard }
}

extension NumericTextStyle where Value == Int64 {
    @usableFromInline static let standard = Self()
}

public extension DiffableTextStyle where Self == NumericTextStyle<Int64> {
    @inlinable static var number: Self { .standard }
}

// MARK: - Floats

extension NumericTextStyle where Value == Float16 {
    @usableFromInline static let standard = Self()
}

public extension DiffableTextStyle where Self == NumericTextStyle<Float16> {
    @inlinable static var number: Self { .standard }
}

extension NumericTextStyle where Value == Float32 {
    @usableFromInline static let standard = Self()
}

public extension DiffableTextStyle where Self == NumericTextStyle<Float32> {
    @inlinable static var number: Self { .standard }
}

extension NumericTextStyle where Value == Float64 {
    @usableFromInline static let standard = Self()
}

public extension DiffableTextStyle where Self == NumericTextStyle<Float64> {
    @inlinable static var number: Self { .standard }
}

// MARK: - Decimals

extension NumericTextStyle where Value == Decimal {
    @usableFromInline static let standard = Self()
}

public extension DiffableTextStyle where Self == NumericTextStyle<Decimal> {
    @inlinable static var number: Self { .standard }
}
