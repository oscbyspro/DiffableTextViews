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
// MARK: Declaration
//*============================================================================*

public enum NumberTextFormatXSign {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case always
    case automatic
}

//*============================================================================*
// MARK: Declaration
//*============================================================================*

public protocol NumberTextFormatXSignRepresentable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ strategy: NumberTextFormatXSign)
}

//*============================================================================*
// MARK: x Number
//*============================================================================*

extension NumberFormatStyleConfiguration.SignDisplayStrategy: NumberTextFormatXSignRepresentable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ other: NumberTextFormatXSign) {
        switch other {
        case .always:    self = .always()
        case .automatic: self = .automatic
        }
    }
}

//*============================================================================*
// MARK: x Currency
//*============================================================================*

extension CurrencyFormatStyleConfiguration.SignDisplayStrategy: NumberTextFormatXSignRepresentable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ other: NumberTextFormatXSign) {
        switch other {
        case .always:    self = .always()
        case .automatic: self = .automatic
        }
    }
}
