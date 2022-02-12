//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import Support

//*============================================================================*
// MARK: * Reader
//*============================================================================*

/// - Snapshot/count is O(1) and may be used without performance impact.
@usableFromInline struct Reader {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let region: Region
    @usableFromInline var changes: Changes
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
            
    @inlinable init(_ changes: Changes, in region: Region) {
        self.region = region
        self.changes = changes
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var ascii: Region { .en_US }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    /// Validates input size and localizes replacement character.
    @inlinable mutating func autocorrect() throws {
        //=--------------------------------------=
        // MARK: Count
        //=--------------------------------------=
        guard changes.replacement.count <= 1 else {
            throw Info([.mark(changes.replacement.characters), "exceeded character size limit", .mark(1)])
        }
        //=--------------------------------------=
        // MARK: Localize
        //=--------------------------------------=
        guard var symbol = changes.replacement.first else { return }
        //=--------------------------------------=
        // MARK: Localize - Match
        //=--------------------------------------=
        if let component = ascii.signs[symbol.character] {
            symbol.character = region.signs[component]
        } else if let component = ascii.digits[symbol.character] {
            symbol.character = region.digits[component]
        } else if let _ = ascii.separators[symbol.character] {
            symbol.character = region.separators[.fraction]
        } else { return }
        //=--------------------------------------=
        // MARK: Localize - Update
        //=--------------------------------------=
        self.changes.replacement = Snapshot([symbol])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Commands
    //=------------------------------------------------------------------------=
    
    /// Interprets a single sign character as a: set sign command.
    @inlinable mutating func consumeSignInput() -> ((inout Number) -> Void)? {
        guard changes.replacement.count == 1 else { return nil } // snapshot.count is O(1)
        guard let sign = region.signs[changes.replacement.first!.character] else { return nil }
        //=--------------------------------------=
        // MARK: Set Sign Command Found
        //=--------------------------------------=
        self.changes.replacement.removeAll()
        return { number in number.sign = sign }
    }
}
