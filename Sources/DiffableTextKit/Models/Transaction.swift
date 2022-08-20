//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#warning("Remove")

//*============================================================================*
// MARK: * Transaction
//*============================================================================*

@usableFromInline struct Transaction<Style: DiffableTextStyle> {
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var status: Status<Style>
    @usableFromInline private(set) var backup: String?
    @usableFromInline private(set) var commit: Commit<Style.Value>?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ status: Status<Style>, with cache: inout Style.Cache, then update: inout Update) {
        self.status = status; update += .text
        //=----------------------------------=
        // Active
        //=----------------------------------=
        if  status.focus == true {
            self.commit = status.interpret(with: &cache)
            
            update += .selection
            update += .value(status.value != commit!.value)
            
            self.status.value = commit!.value
        //=----------------------------------=
        // Inactive
        //=----------------------------------=
        } else { self.backup = status.format(with: &cache) }
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal func layout() -> Layout? {
        commit.map({ Layout($0.snapshot, preference: $0.selection) })
    }
}
