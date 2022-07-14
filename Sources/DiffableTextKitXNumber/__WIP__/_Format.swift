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

public protocol _Format: ParseableFormatStyle  where
FormatInput: NumberTextValue, FormatOutput == String {
    associatedtype _Sign: NumberTextFormatXSignRepresentable
    associatedtype _Increment
    
    //=------------------------------------------------------------------------=
    // MARK: Types
    //=------------------------------------------------------------------------=
    
    typealias NFSC = NumberFormatStyleConfiguration
    typealias CFSC = CurrencyFormatStyleConfiguration
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var locale: Locale { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: _Sign) -> Self
    
    @inlinable func precision(_ precision: NFSC.Precision) -> Self
    
    @inlinable func decimalSeparator(strategy: NFSC.DecimalSeparatorDisplayStrategy) -> Self
    
    @inlinable func rounded(rule: FloatingPointRoundingRule, increment: _Increment?) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Format {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(_ sign: Sign) -> Self {
        self.sign(strategy: .init(sign == .negative ? .always : .automatic))
    }
    
    @inlinable func separator(_ separator: Separator?) -> Self {
        self.decimalSeparator(strategy: separator != nil ? .always : .automatic)
    }
    
    @inlinable func rounded(_ rule: FloatingPointRoundingRule) -> Self {
        self.rounded(rule: rule, increment: nil)
    }
}

//*============================================================================*
// MARK: * Format x Standard
//*============================================================================*

public protocol _Format_Standard: _Format
where _Sign == NFSC.SignDisplayStrategy {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale)
}

//*============================================================================*
// MARK: * Format x Number
//*============================================================================*

public protocol _Format_Number: _Format_Standard { }

//*============================================================================*
// MARK: * Format x Currency
//*============================================================================*

public protocol _Format_Currency: _Format
where _Sign == CFSC.SignDisplayStrategy {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    @inlinable init(code: String, locale: Locale)
}

//*============================================================================*
// MARK: * Format x Percent
//*============================================================================*

public protocol _Format_Percent: _Format_Standard { }

//*============================================================================*
// MARK: * Format x Branchable(s)
//*============================================================================*

public protocol _Format_Numberable: _Format {
    associatedtype Number: _Format_Number
    where Number.FormatInput == FormatInput
}

public protocol _Format_Currencyable: _Format {
    associatedtype Currency: _Format_Currency
    where Currency.FormatInput == FormatInput
}

public protocol _Format_Percentable: _Format {
    associatedtype Percent: _Format_Percent
    where Percent.FormatInput == FormatInput
}
