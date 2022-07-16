//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#warning("Rename as Value, maybe?")
//*============================================================================*
// MARK: * Kind
//*============================================================================*

public protocol _Kind {
    associatedtype NumberTextGraph: _Graph where NumberTextGraph.Style.Value == Self
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable static var isOptional: Bool { get }
    @inlinable static var isUnsigned: Bool { get }
    @inlinable static var isInteger:  Bool { get }
}
