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
// MARK: * Preferences
//*============================================================================*

@usableFromInline struct _Preferences<Input> where Input: _Input {
    @usableFromInline typealias Bounds = _Bounds<Input>
    @usableFromInline typealias Precision = _Precision<Input>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let bounds: Bounds
    @usableFromInline let precision: Precision
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(bounds: Bounds, precision: Precision) {
        self.bounds = bounds; self.precision = precision
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func standard() -> Self {
        Self(bounds: Bounds(), precision: Precision())
    }
    
    /// - Requires that formatter.numberStyle == .currency.
    /// - Requires that formatter.maximumFractionDigits == default.
    /// 
    @inlinable static func currency(_ formatter: NumberFormatter) -> Self {
        assert(formatter.numberStyle == .currency)
        
        let precision = Precision(fraction:
        formatter.minimumFractionDigits ..<
        formatter.maximumFractionDigits)
        
        return Self(bounds: Bounds(), precision: precision)
    }
}
