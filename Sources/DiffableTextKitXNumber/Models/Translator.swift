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
    
    @usableFromInline private(set) var storage = [Character: Character]()
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ local: Components) {
        self.insert(\.signs,      from: .ascii, to: local, as: { $0 })
        self.insert(\.digits,     from: .ascii, to: local, as: { $0 })
        self.insert(\.separators, from: .ascii, to: local, as: { _ in .fraction })
        self.insert(\.separators, from:  local, to: local, as: { _ in .fraction })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(symbol: Symbol) -> Symbol {
        Symbol(self[symbol.character], as: symbol.attribute)
    }
    
    @inlinable subscript(character: Character) -> Character {
        storage[character] ?? character
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func insert<T>(_ links: (Components)  ->  Links<T>,
    from source: Components, to destination: Components, as key: (T) -> T) {
        let source      = links(source)     .characters
        let destination = links(destination).characters
        
        for (token, character) in source {
            storage[character] = destination[key(token)]
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func translateSingleSymbol(in snapshot: inout Snapshot) {
        guard snapshot.count == 1 else { return }
        snapshot = snapshot.reduce(into: .init()) { $0.append(self[$1]) }
    }
}
