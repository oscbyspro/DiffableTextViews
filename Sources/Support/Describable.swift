//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Describable
//*============================================================================*

public protocol Describable: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Content
    //=------------------------------------------------------------------------=
    
    @inlinable var descriptors: [(key: Any, value: Any)] { get }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

public extension Describable {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable var description: String {
        "\(Self.self)(\(descriptors.map({"\($0.0): \($0.1)"}).joined(separator: ", ")))"
    }
}
