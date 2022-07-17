//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

#warning("Rework: NumberTextGraph.............................................")
//*============================================================================*
// MARK: * Format
//*============================================================================*

public protocol _Format: ParseableFormatStyle where FormatInput: _Input, FormatOutput == String {
    associatedtype NumberTextGraph: _DefaultGraph where NumberTextGraph.Format == Self
    
    //=------------------------------------------------------------------------=
    // MARK: Types
    //=------------------------------------------------------------------------=
    
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
    
    @inlinable func rounded(_ rule: _FPRR) -> Self {
        self.rounded(rule: rule, increment: nil)
    }
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

//*============================================================================*
// MARK: * Format x Number
//*============================================================================*

public protocol _Format_Number: _Format_Standard { }

//*============================================================================*
// MARK: * Format x Percent
//*============================================================================*

public protocol _Format_Percent: _Format_Standard { }

//*============================================================================*
// MARK: * Format x Currency
//*============================================================================*

public protocol _Format_Currency: _Format where _SignDS == _CFSC_SignDS {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    @inlinable init(code: String, locale: Locale)
}

//*============================================================================*
// MARK: * Format x Branchable(s)
//*============================================================================*

public protocol _Format_Numberable: _Format {
    associatedtype Number: _Format_Number
    where Number.FormatInput == FormatInput
}

public protocol _Format_Percentable: _Format {
    associatedtype Percent: _Format_Percent
    where Percent.FormatInput == FormatInput
}

public protocol _Format_Currencyable: _Format {
    associatedtype Currency: _Format_Currency
    where Currency.FormatInput == FormatInput
}

//*============================================================================*
// MARK: * Format x Strategies x Sign
//*============================================================================*

public enum _SignDS {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case always
    case automatic
}

//=----------------------------------------------------------------------------=
// MARK: + Protocol
//=----------------------------------------------------------------------------=

public protocol _SignDS_Init {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ value: _SignDS)
}

//=----------------------------------------------------------------------------=
// MARK: + Number
//=----------------------------------------------------------------------------=

extension _NFSC_SignDS: _SignDS_Init {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ value: _SignDS) {
        switch value {
        case .always:    self = .always()
        case .automatic: self = .automatic
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Currency
//=----------------------------------------------------------------------------=

extension _CFSC_SignDS: _SignDS_Init {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ value: _SignDS) {
        switch value {
        case .always:    self = .always()
        case .automatic: self = .automatic
        }
    }
}
