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
// MARK: * Table of Contents
//*============================================================================*

@usableFromInline typealias SignStyle = NumericTextSignDisplayStyle
@usableFromInline typealias PrecisionStyle = NumberFormatStyleConfiguration.Precision
@usableFromInline typealias SeparatorStyle = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy

//*============================================================================*
// MARK: * NumericTextSignDisplayStyle
//*============================================================================*

public enum NumericTextSignDisplayStyle {

    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case always
    case automatic
}

//*============================================================================*
// MARK: * Sign x Representable
//*============================================================================*

public protocol NumericTextSignDisplayStyleRepresentable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(style: NumericTextSignDisplayStyle)
}

//*============================================================================*
// MARK: * Sign x Representable x Number
//*============================================================================*

extension NumberFormatStyleConfiguration.SignDisplayStrategy: NumericTextSignDisplayStyleRepresentable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(style: NumericTextSignDisplayStyle) {
        switch style { case .always: self = .always(); case .automatic: self = .automatic }
    }
}

//*============================================================================*
// MARK: * Sign x Representable x Currency
//*============================================================================*

extension CurrencyFormatStyleConfiguration.SignDisplayStrategy: NumericTextSignDisplayStyleRepresentable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(style: NumericTextSignDisplayStyle) {
        switch style { case .always: self = .always(); case .automatic: self = .automatic }
    }
}
