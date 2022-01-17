//
//  NumericTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import DiffableTextViews
import Foundation

//*============================================================================*
// MARK: * NumericTextStyle
//*============================================================================*

public struct NumericTextStyle<Format: NumericTextStyles.Format>: DiffableTextStyle
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
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(format: Format, locale: Locale = .autoupdatingCurrent) {
        self.format = format
        self.region = .cached(locale)
        self.bounds = .standard
        self.precision = .standard
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var parser: Format.Strategy {
        format.parseStrategy
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        var result = self
        result.format = format.locale(locale)
        result.region = Region.cached(locale)
        return result
    }
    
    @inlinable public func bounds(_ bounds: Bounds) -> Self {
        var result = self
        result.bounds = bounds
        return result
    }
    
    @inlinable public func precision(_ precision: Precision) -> Self {
        var result = self
        result.precision = precision
        return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Formats - Showcase
    //=------------------------------------------------------------------------=
    
    @inlinable func showcaseStyle() -> Format {
        format.style(precision: precision.showcaseStyle())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Formats - Editable
    //=------------------------------------------------------------------------=
    
    @inlinable func editableStyle() -> Format {
        format.style(precision: precision.editableStyle())
    }
    
    @inlinable func editableStyle(number: Number) -> Format {
        let precision: Format.Precision = precision.editableStyle(number: number)
        let separator: Format.Separator = number.separator == .fraction ? .always : .automatic
        let sign: Sign.Style = number.sign == .negative ? .always : .automatic
        return format.style(precision: precision, separator: separator, sign: sign)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrectSign(in characters: inout String, with value: Value, and sign: Sign) {
        guard sign == .negative && value == .zero else { return }
        guard let position = characters.firstIndex(where: region.signs.components.keys.contains) else { return }
        guard let replacement = region.signs[sign] else { return }
        characters.replaceSubrange(position...position, with: String(replacement))
    }
}
