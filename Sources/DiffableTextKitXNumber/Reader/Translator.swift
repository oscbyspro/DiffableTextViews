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
    @usableFromInline typealias Map = [Character: Character]
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let map: Map
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ local: Components) {
        var map = Map()
        //=--------------------------------------=
        // Reduce
        //=--------------------------------------=
        Self.reduce(into: &map, from: .ascii, to: local, all: \.digits,     as: { $0 })
        Self.reduce(into: &map, from: .ascii, to: local, all: \.separators, as: { _ in .fraction })
        Self.reduce(into: &map, from:  local, to: local, all: \.separators, as: { _ in .fraction })
        Self.reduce(into: &map, from: .ascii, to: local, all: \.signs,      as: { $0 })
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        self.map = map
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
    
    @inlinable static func reduce<T>(into map: inout Map,
    from  source:  Components, to destination: Components,
    all elements: (Components) -> Links<T>, as key: (T) -> T) {
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
