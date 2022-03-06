//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * CustomStringConvertible x Description
//*============================================================================*

public extension CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable func description(_ content: [(label: Any, value: Any)]) -> String {
        "\(Self.self)(\(content.map({"\($0.label): \($0.value)"}).joined(separator: ", ")))"
    }
}
