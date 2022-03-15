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
// MARK: * Source
//*============================================================================*

@usableFromInline final class Source {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let wrapped: NumberFormatter
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ wrapped: NumberFormatter) { self.wrapped = wrapped }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var integerLimits: ClosedRange<Int> {
        wrapped.minimumIntegerDigits ...
        wrapped.maximumIntegerDigits
    }
    
    @inlinable var fractionLimits: ClosedRange<Int> {
        wrapped.minimumFractionDigits ...
        wrapped.maximumFractionDigits
    }
}
