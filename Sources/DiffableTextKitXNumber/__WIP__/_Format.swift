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

public protocol _Format: ParseableFormatStyle where FormatInput: _Input, FormatOutput == String {
    associatedtype _Increment
    associatedtype _SignDS: _SignDS_Init
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var locale: Locale { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: _SignDS) -> Self
    
    @inlinable func precision(_ precision: _NFSC.Precision) -> Self
    
    @inlinable func decimalSeparator(strategy: _NFSC_SeparatorDS) -> Self
    
    @inlinable func rounded(rule: _FPRR, increment: _Increment?) -> Self
}

//*============================================================================*
// MARK: * Format x Standard
//*============================================================================*

public protocol _Format_Standard: _Format where _SignDS == _NFSC_SignDS {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale)
}

//=----------------------------------------------------------------------------=
// MARK: + Types
//=----------------------------------------------------------------------------=

private typealias _Standard = _Format & _Format_Standard

extension      Decimal.FormatStyle: _Standard { }
extension FloatingPointFormatStyle: _Standard where FormatInput: _Input { }
extension       IntegerFormatStyle: _Standard where FormatInput: _Input { }

extension      Decimal.FormatStyle.Percent: _Standard { }
extension FloatingPointFormatStyle.Percent: _Standard where FormatInput: _Input { }

//*============================================================================*
// MARK: * Format x Currency
//*============================================================================*

public protocol _Format_Currency: _Format where _SignDS == _CFSC_SignDS {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    @inlinable init(code: String, locale: Locale)
}

//=----------------------------------------------------------------------------=
// MARK: + Types
//=----------------------------------------------------------------------------=

private typealias _Currency = _Format & _Format_Currency

extension      Decimal.FormatStyle.Currency: _Currency { }
extension FloatingPointFormatStyle.Currency: _Currency where FormatInput: _Input { }
extension       IntegerFormatStyle.Currency: _Currency where FormatInput: _Input { }

//*============================================================================*
// MARK: * Format x Strategies x Sign
//*============================================================================*

public enum     _SignDS      { case always, automatic }
public protocol _SignDS_Init { init(_ value: _SignDS) }

//=----------------------------------------------------------------------------=
// MARK: + Types
//=----------------------------------------------------------------------------=

extension _NFSC_SignDS: _SignDS_Init {
    @inlinable public init(_ value: _SignDS) {
        switch value { case .always: self = .always(); case .automatic: self = .automatic }
    }
}

extension _CFSC_SignDS: _SignDS_Init {
    @inlinable public init(_ value: _SignDS) {
        switch value { case .always: self = .always(); case .automatic: self = .automatic }
    }
}
