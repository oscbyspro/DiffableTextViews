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
// MARK: * NumericTextSignDisplayStrategy
//*============================================================================*

public enum NumericTextSignDisplayStrategy {

    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case always
    case automatic
}

//*============================================================================*
// MARK: * NumericTextSignDisplayStrategy x Representable
//*============================================================================*

public protocol NumericTextSignDisplayStrategyRepresentable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ strategy: NumericTextSignDisplayStrategy)
}

//*============================================================================*
// MARK: * NumericTextSignDisplayStrategy x Representable x Number
//*============================================================================*

extension NumberFormatStyleConfiguration.SignDisplayStrategy: NumericTextSignDisplayStrategyRepresentable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ strategy: NumericTextSignDisplayStrategy) {
        switch strategy { case .always: self = .always(); case .automatic: self = .automatic }
    }
}

//*============================================================================*
// MARK: * NumericTextSignDisplayStrategy x Representable x Currency
//*============================================================================*

extension CurrencyFormatStyleConfiguration.SignDisplayStrategy: NumericTextSignDisplayStrategyRepresentable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ strategy: NumericTextSignDisplayStrategy) {
        switch strategy { case .always: self = .always(); case .automatic: self = .automatic }
    }
}
