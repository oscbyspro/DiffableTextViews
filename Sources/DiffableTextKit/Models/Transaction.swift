//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Transaction [...]
//*============================================================================*

@usableFromInline struct Transaction<Style: DiffableTextStyle> {
    
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var status: Status<Style>
    @usableFromInline private(set) var backup: String?
    @usableFromInline private(set) var commit: Commit<Style.Value>?
    
    //=------------------------------------------------------------------------=
    
    /// - Observing changes on view setup is free and/or infrequent.
    @inlinable init(_ status: Status<Style>, with cache: inout Style.Cache,
    observing changes: inout Changes) {
        self.status = status
        //=----------------------------------=
        // Active
        //=----------------------------------=
        if  status.focus == true {
            self.commit = status.interpret(with: &cache)
            changes += .value(status.value != commit!.value)
            self.status.value = commit!.value
        //=----------------------------------=
        // Inactive
        //=----------------------------------=
        } else { self.backup = status.format(with: &cache) }
    }
    
    @inlinable internal func layout() -> Layout? {
        commit.map({ Layout($0.snapshot, preference: $0.selection) })
    }
}
