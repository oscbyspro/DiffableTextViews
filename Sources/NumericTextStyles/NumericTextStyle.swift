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

public struct NumericTextStyle<Format: NumericTextStyles.Format>: DiffableTextStyle, Mappable
where Format.FormatInput: Valuable, Format.FormatOutput == String {
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
        self.region = Region.reusable(locale)
        self.bounds = Bounds.standard
        self.precision = Precision.standard
        self.prefix = ""
        self.suffix = ""
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        map({ $0.region = .reusable(locale) })
    }
    
    @inlinable public func bounds(_ bounds: Bounds) -> Self {
        map({ $0.bounds = bounds })
    }
    
    @inlinable public func precision(_ precision: Precision) -> Self {
        map({ $0.precision = precision })
    }
    
    @inlinable public func prefix(_ prefix: String?) -> Self {
        map({ $0.prefix = prefix ?? "" })
    }
    
    @inlinable public func suffix(_ suffix: String?) -> Self {
        map({ $0.suffix = suffix ?? "" })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Styles
    //=------------------------------------------------------------------------=
    
    @inlinable func showcaseStyle() -> Format {
        format.style(locale: region.locale, precision: precision.showcaseStyle(), separator: .automatic)
    }
    
    @inlinable func editableStyle() -> Format {
        format.style(locale: region.locale, precision: precision.editableStyle(), separator: .automatic)
    }
    
    @inlinable func editableStyleThatUses(number: Number) -> Format {
        let separator: Value.SeparatorStyle = number.separator == .some ? .always : .automatic
        let precision: Value.PrecisionStyle = precision.editableStyleThatUses(number: number)
        return format.style(locale: region.locale, precision: precision, separator: separator)
    }
}
