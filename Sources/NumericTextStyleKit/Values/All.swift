//
//  All.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import struct Foundation.Decimal

// MARK: - Protocols

public protocol NumericTextStyleOfInt: NumericTextStyle where Value == Int { }
public protocol NumericTextStyleOfInt8: NumericTextStyle where Value == Int8 { }
public protocol NumericTextStyleOfInt16: NumericTextStyle where Value == Int16 { }
public protocol NumericTextStyleOfInt32: NumericTextStyle where Value == Int32 { }
public protocol NumericTextStyleOfInt64: NumericTextStyle where Value == Int64 { }
public protocol NumericTextStyleOfUInt: NumericTextStyle where Value == UInt { }
public protocol NumericTextStyleOfUInt8: NumericTextStyle where Value == UInt8 { }
public protocol NumericTextStyleOfUInt16: NumericTextStyle where Value == UInt16 { }
public protocol NumericTextStyleOfUInt32: NumericTextStyle where Value == UInt32 { }
public protocol NumericTextStyleOfUInt64: NumericTextStyle where Value == UInt64 { }
// --------------------------------- //
public protocol NumericTextStyleOfFloat16: NumericTextStyle where Value == Float16 { }
public protocol NumericTextStyleOfFloat32: NumericTextStyle where Value == Float32 { }
public protocol NumericTextStyleOfFloat64: NumericTextStyle where Value == Float64 { }
// --------------------------------- //
public protocol NumericTextStyleOfDecimal: NumericTextStyle where Value == Decimal { }

// MARK: - Styles

extension Style: NumericTextStyleOfInt where Value == Int { }
extension Style: NumericTextStyleOfInt8 where Value == Int8 { }
extension Style: NumericTextStyleOfInt16 where Value == Int16 { }
extension Style: NumericTextStyleOfInt32 where Value == Int32 { }
extension Style: NumericTextStyleOfInt64 where Value == Int64 { }
extension Style: NumericTextStyleOfUInt where Value == UInt { }
extension Style: NumericTextStyleOfUInt8 where Value == UInt8 { }
extension Style: NumericTextStyleOfUInt16 where Value == UInt16 { }
extension Style: NumericTextStyleOfUInt32 where Value == UInt32 { }
extension Style: NumericTextStyleOfUInt64 where Value == UInt64 { }
// --------------------------------- //
extension Style: NumericTextStyleOfFloat16 where Value == Float16 { }
extension Style: NumericTextStyleOfFloat32 where Value == Float32 { }
extension Style: NumericTextStyleOfFloat64 where Value == Float64 { }
// --------------------------------- //
extension Style: NumericTextStyleOfDecimal where Value == Decimal { }
