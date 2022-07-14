//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * Style
//*============================================================================*

public protocol _Style: DiffableTextStyle, _Style_Bounds, _Style_Precision where
Cache: _Cache, Cache.Style == Self, Value: NumberTextValue { }

//*============================================================================*
// MARK: * Style x Internal
//*============================================================================*

@usableFromInline protocol _Style_Internal: _Style, _Style_Bounds_Internal, _Style_Precision_Internal {
    associatedtype Key: Hashable
    
    typealias Bounds = NumberTextBounds<Value>
    typealias Precision = NumberTextPrecision<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var key: Key { get set }
    @inlinable var bounds: Bounds? { get set }
    @inlinable var precision: Precision? { get set }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Style_Internal {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func bounds(_ bounds: NumberTextBounds<Value>) -> Self {
        var result = self; result.bounds = bounds; return result
    }
    
    @inlinable public func precision(_ precision: NumberTextPrecision<Value>) -> Self {
        var result = self; result.precision = precision; return result
    }
}
