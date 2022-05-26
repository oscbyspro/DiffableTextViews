//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//*============================================================================*
// MARK: * Translator
//*============================================================================*

@usableFromInline struct Translator {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var map = [Character: Character]()
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ local: Components) {
        self.insert(\.digits,     from: .ascii, to: local, as: { $0 })
        self.insert(\.separators, from: .ascii, to: local, as: { _ in .fraction })
        self.insert(\.separators, from:  local, to: local, as: { _ in .fraction })
        self.insert(\.signs,      from: .ascii, to: local, as: { $0 })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(character: Character) -> Character {
        map[character] ?? character
    }
    
    @inlinable subscript(symbol: Symbol) -> Symbol {
        Symbol(self[symbol.character], as: symbol.attribute)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func translateSingleSymbol(in proposal: inout Proposal) {
        guard proposal.replacement.count == 1 else { return }
        proposal.replacement = Snapshot(proposal.replacement.map({ self[$0] }))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func insert<T>(_ elements: (Components) -> Links<T>,
    from source: Components, to destination: Components, as key: (T) -> T) {
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        let source      = elements(source)
        let destination = elements(destination)
        //=--------------------------------------=
        // Reduce
        //=--------------------------------------=
        for (component, character) in source.characters {
            map[character] = destination[key(component)]
        }
    }
}
