//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Value
//*============================================================================*

public protocol _Value {
    associatedtype NumberTextStyle: _Protocol // node
    typealias NumberTextGraph = NumberTextStyle.Graph
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable static var isOptional: Bool { get }
    @inlinable static var isUnsigned: Bool { get }
    @inlinable static var isInteger:  Bool { get }
}
