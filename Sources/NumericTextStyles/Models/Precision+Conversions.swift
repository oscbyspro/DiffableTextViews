//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension Precision: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        func text(component:  Count.Component) -> String {
            "\(component): \((lower[component], upper[component]))"
        }
        //=--------------------------------------=
        // MARK: Make
        //=--------------------------------------=
        var description = "\(Self.self)("
        description += Count.Component.allCases
        .lazy.map(text).joined(separator: ", ")
        description += ")"; return description
    }
}
