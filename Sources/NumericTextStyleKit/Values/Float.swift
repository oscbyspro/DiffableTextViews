////
////  NumericTextSchemeOfFloat.swift
////  
////
////  Created by Oscar Byström Ericsson on 2021-10-25.
////
//
//#if os(iOS)
//
//import struct Foundation.Locale
//import struct Foundation.FloatingPointFormatStyle
//
//// MARK: - NumericTextFloat
//
///// NumericTextSchemeOfFloat.
/////
///// - Range: ±Self.maxLosslessValue.
///// - Significands: Self.maxLosslessDigits.
//@usableFromInline protocol Float: NumericTextValueAsFloat, BinaryFloatingPoint {
//    @inlinable init?(_ description: String)
//}
//
//// MARK: - Defaults
//
//extension Float {
//    
//    // MARK: Bounds
//    
//    @inlinable static var minLosslessValue: Self { -maxLosslessValue }
//
//    // MARK: Utilities
//
//    @inlinable static func value(_ components: Components) -> Self? {
//        .init(components.characters())
//    }
//    
//    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> FloatingPointFormatStyle<Self> {
//        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
//    }
//}
//
//// MARK: - Float16
//
//public protocol NumericTextStyleOfFloat16: NumericTextStyle where Value == Float16 { }
//extension Style: NumericTextStyleOfFloat16 where Value == Float16 { }
//
//extension Float16: Float {
//    @inlinable static var maxLosslessValue: Self { 999 }
//    @inlinable static var maxLosslessDigits: Int {   3 }
//    
//    public static func numericTextStyle(_ locale: Locale) -> some NumericTextStyleOfFloat16 {
//        Style(locale: locale)
//    }
//}
//
//// MARK: - Float32
//
//public protocol NumericTextStyleOfFloat32: NumericTextStyle where Value == Float32 { }
//extension Style: NumericTextStyleOfFloat32 where Value == Float32 { }
//
//extension Float32: Float {
//    @inlinable static var maxLosslessValue: Self { 9_999_999 }
//    @inlinable static var maxLosslessDigits: Int {         7 }
//    
//    public static func numericTextStyle(_ locale: Locale) -> some NumericTextStyleOfFloat32 {
//        Style(locale: locale)
//    }
//}
//
//// MARK: - Float64
//
//public protocol NumericTextStyleOfFloat64: NumericTextStyle where Value == Float64 { }
//extension Style: NumericTextStyleOfFloat64 where Value == Float64 { }
//
//extension Float64: Float {
//    @inlinable static var maxLosslessValue: Self { 999_999_999_999_999 }
//    @inlinable static var maxLosslessDigits: Int { 15 }
//    
//    public static func numericTextStyle(_ locale: Locale) -> some NumericTextStyleOfFloat64 {
//        Style(locale: locale)
//    }
//}
//
//#endif
