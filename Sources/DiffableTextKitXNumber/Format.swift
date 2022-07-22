//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Format
//*============================================================================*

public protocol _Format: ParseableFormatStyle where FormatOutput == String {
    
    associatedtype _Increment
    
    associatedtype _SignDS: _SignDS_Init
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: _SignDS) -> Self
    
    @inlinable func precision(_ precision: _NFSC.Precision) -> Self
    
    @inlinable func decimalSeparator(strategy: _NFSC_SeparatorDS) -> Self
    
    @inlinable func rounded(rule: _FPRR,  increment: _Increment?) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Format {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func number(_ number: Number) -> Self {
        let sign = _SignDS(number.sign == .negative ?  .always : .automatic)
        let separator = number.separator != nil ? _NFSC_SeparatorDS.always : .automatic
        return decimalSeparator(strategy: separator).sign(strategy: sign)
    }
}

//*============================================================================*
// MARK: * Format x Standard
//*============================================================================*

extension      Decimal.FormatStyle: _Format & _Standard { }
extension FloatingPointFormatStyle: _Format & _Standard { }
extension       IntegerFormatStyle: _Format & _Standard { }

extension      Decimal.FormatStyle.Percent: _Format & _Standard { }
extension FloatingPointFormatStyle.Percent: _Format & _Standard { }

//*============================================================================*
// MARK: * Format x Currency
//*============================================================================*

extension      Decimal.FormatStyle.Currency: _Format & _Currency { }
extension FloatingPointFormatStyle.Currency: _Format & _Currency { }
extension       IntegerFormatStyle.Currency: _Format & _Currency { }

//*============================================================================*
// MARK: * Format x Strategy x Sign
//*============================================================================*

public enum     _SignDS      { case always, automatic }
public protocol _SignDS_Init { init(_ value: _SignDS) }

//=----------------------------------------------------------------------------=
// MARK: + Types
//=----------------------------------------------------------------------------=

extension _NFSC_SignDS: _SignDS_Init {
    @inlinable public init(_ value: _SignDS) { switch value {
        case .always:    self = .always()
        case .automatic: self = .automatic }
    }
}

extension _CFSC_SignDS: _SignDS_Init {
    @inlinable public init(_ value: _SignDS) { switch value {
        case .always:    self = .always()
        case .automatic: self = .automatic }
    }
}
