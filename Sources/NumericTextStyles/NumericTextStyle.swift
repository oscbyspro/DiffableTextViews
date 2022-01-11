//
//  NumericTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import DiffableTextViews
import Foundation
import Quick
import Utilities

//*============================================================================*
// MARK: * NumericTextStyle
//*============================================================================*

public struct NumericTextStyle<Value: Valuable>: DiffableTextStyle, Mappable {
    public typealias Bounds = NumericTextStyles.Bounds<Value>
    public typealias Precision = NumericTextStyles.Precision<Value>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var region: Region
    @usableFromInline var bounds: Bounds
    @usableFromInline var precision: Precision
    @usableFromInline var prefix: String
    @usableFromInline var suffix: String
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
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
    
    @inlinable func showcaseStyle() -> Value.FormatStyle {
        Value.style(locale: region.locale, precision: precision.showcaseStyle(), separator: .automatic)
    }
        
    @inlinable func editableStyle() -> Value.FormatStyle {
        Value.style(locale: region.locale, precision: precision.editableStyle(), separator: .automatic)
    }
    
    @inlinable func editableStyleThatUses(number: Number) -> Value.FormatStyle {
        let separator: Value.SeparatorStyle = number.separator == .some ? .always : .automatic
        let precision: Value.PrecisionStyle = precision.editableStyleThatUses(number: number)
        return Value.style(locale: region.locale, precision: precision, separator: separator)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Validation - Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func correct(sign: inout Sign) {
        switch sign {
        case .positive:
            if bounds.max >  .zero { break }
            if bounds.min == .zero { break }
            sign.toggle()
        case .negative:
            if bounds.min <  .zero { break }
            sign.toggle()
        }
    }
    
    @inlinable func validate(sign: Sign) throws {
        var subject = sign; correct(sign: &subject)

        guard sign == subject else {
            throw Info([.mark(sign), "is not permitted in", .mark(bounds)])
        }
    }
    
    //
    // MARK: Validation - Value
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(value: Value) throws {
        guard bounds.contains(value) else {
            throw Info([.mark(value), "is not in", .mark(bounds)])
        }
    }
}
