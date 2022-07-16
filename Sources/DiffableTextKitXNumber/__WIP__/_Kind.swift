//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Kind
//*============================================================================*

public protocol _Kind {
    
    //=------------------------------------------------------------------------=
    // MARK: Style
    //=------------------------------------------------------------------------=
    
    associatedtype NumberTextID: _Key
    
    typealias NumberTextStyle  = NumberTextID.Style
    typealias NumberTextCache  = NumberTextID.Cache
    typealias NumberTextFormat = NumberTextID.Format

    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable static var isOptional: Bool { get }
    @inlinable static var isUnsigned: Bool { get }
    @inlinable static var isInteger:  Bool { get }
}
