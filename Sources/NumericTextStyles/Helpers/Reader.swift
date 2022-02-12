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
        guard let localized = changes.replacement.first.flatMap(localized) else { return }
        self.changes.replacement = Snapshot([localized])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func localized(input: Symbol) -> Symbol? {
        let ascii = Region.en_US
        var character = input.character
        //=--------------------------------------=
        // MARK: Match
        //=--------------------------------------=
        if let component = ascii.signs[character] {
            character = region.signs[component]
        } else if let component = ascii.digits[character] {
            character = region.digits[component]
        } else if let _ = ascii.separators[character] {
            character = region.separators[Separator.fraction]
        } else { return nil }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return Symbol(character, as: input.attribute)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Commands
//=----------------------------------------------------------------------------=

extension Reader {
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
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
