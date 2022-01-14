//
//  NumericTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import DiffableTextViews
import Foundation
import Quick

//*============================================================================*
// MARK: * NumericTextStyle
//*============================================================================*

public struct NumericTextStyle<Format: NumericTextStyles.Format>: DiffableTextStyle, Transformable
    where Format.FormatInput: Value, Format.FormatOutput == String {
    public typealias Value = Format.FormatInput
    public typealias Bounds = NumericTextStyles.Bounds<Value>
    public typealias Precision = NumericTextStyles.Precision<Value>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var format: Format
    @usableFromInline var region: Region
    @usableFromInline var bounds: Bounds
    @usableFromInline var precision: Precision
    @usableFromInline var prefix: String
    @usableFromInline var suffix: String
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(format: Format, locale: Locale = .autoupdatingCurrent) {
        self.format = format
        self.region = .reusable(locale)
        self.bounds = .standard
        self.precision = .standard
        self.prefix = ""
        self.suffix = ""
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        var result = self
        result.format = format.locale(locale)
        result.region = Region.reusable(locale)
        return result
    }
    
    @inlinable public func bounds(_ bounds: Bounds) -> Self {
        transform({ $0.bounds = bounds })
    }
    
    @inlinable public func precision(_ precision: Precision) -> Self {
        transform({ $0.precision = precision })
    }
    
    @inlinable public func prefix(_ prefix: String?) -> Self {
        transform({ $0.prefix = prefix ?? String() })
    }
    
    @inlinable public func suffix(_ suffix: String?) -> Self {
        transform({ $0.suffix = suffix ?? String() })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Styles
    //=------------------------------------------------------------------------=
    
    @inlinable func showcaseStyle() -> Format {
        style(precision: precision.showcaseStyle())
    }
    
    @inlinable func editableStyle() -> Format {
        style(precision: precision.editableStyle())
    }
    
    @inlinable func editableStyle(number: Number) -> Format {
        let precision: Format.PrecisionStyle = precision.editableStyleThatUses(number: number)
        let separator: Format.SeparatorStyle = number.separator == .fraction ? .always : .automatic
        let sign: Sign.Style = number.sign == .negative ? .always : .automatic
        return style(precision: precision, separator: separator, sign: sign)
    }
    
    //
    // MARK: Styles - Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func style(
        precision: Format.PrecisionStyle,
        separator: Format.SeparatorStyle = .automatic,
        sign: Sign.Style = .automatic) -> Format {
        format.precision(precision).decimalSeparator(strategy: separator).sign(style: sign)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Uilities
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrectSign(in characters: inout String, with value: Value, and sign: Sign) {
        guard sign == .negative && value == .zero else { return }
        guard let position = characters.firstIndex(where: region.signs.keys.contains) else { return }
        guard let sign = region.signsInLocale[sign] else { return }
        characters.replaceSubrange(position...position, with: String(sign))
    }
}
