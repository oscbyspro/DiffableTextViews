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
// MARK: * Mock
//*============================================================================*

struct Mock: DiffableTextStyle {
    typealias Value = Int
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    var locale: Locale
        
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    func locale(_ locale: Locale) -> Self {
        var result = self; result.locale = locale; return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func format(_ value: Value, with cache: inout Void) -> String {
        fatalError()
    }
    
    func interpret(_ value: Value, with cache: inout Void) -> Commit<Value> {
        fatalError()
    }
    
    func resolve(_ proposal: Proposal, with cache: inout Void) throws -> Commit<Value> {
        fatalError()
    }
}
