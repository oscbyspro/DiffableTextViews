//
//  Format.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-25.
//

import Foundation
import Utilities

//*============================================================================*
// MARK: * Format
//*============================================================================*

@usableFromInline struct Format<Value: Valuable> {
    @usableFromInline typealias Bounds = NumericTextStyles.Bounds<Value>
    @usableFromInline typealias Precision = NumericTextStyles.Precision<Value>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var region: Region
    @usableFromInline var bounds: Bounds
    @usableFromInline var precision: Precision

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(region: Region) {
        self.region = region
        self.bounds = .standard
        self.precision = .standard
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
        let separator: Value.SeparatorStyle = number.separator ? .always : .automatic
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
