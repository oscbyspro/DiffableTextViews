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
// MARK: * Wrapper
//*============================================================================*

public protocol WrapperTextStyle: DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Style
    //=------------------------------------------------------------------------=
    
    associatedtype Style: DiffableTextStyle

    @inlinable var style: Style { get set }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension WrapperTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func locale(_ locale: Locale) -> Self {
        var result = self
        result.style = result.style.locale(locale)
        return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func format(_ value: Value) -> String
    where Value == Style.Value {
        style.format(value)
    }

    @inlinable @inline(__always)
    public func interpret(_ value: Value) -> Commit<Value>
    where Value == Style.Value {
        style.interpret(value)
    }

    @inlinable @inline(__always)
    public func resolve(_ proposal: Proposal) throws -> Commit<Value>
    where Value == Style.Value {
        try style.resolve(proposal)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.style == rhs.style
    }
}
