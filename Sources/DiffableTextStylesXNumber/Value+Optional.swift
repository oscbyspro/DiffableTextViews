//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: Extension
//*============================================================================*

extension Optional: NumberTextKind where Wrapped: NumberTextValue {
    public typealias NumberTextStyle = _OptionalNumberTextStyle<Wrapped.NumberTextFormat>
    
    //=------------------------------------------------------------------------=
    // MARK: Requirements
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isOptional: Bool { true }
    @inlinable public static var isUnsigned: Bool { Wrapped.isUnsigned }
    @inlinable public static var isInteger:  Bool { Wrapped.isInteger  }
}
