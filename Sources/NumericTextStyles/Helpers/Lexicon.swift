//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation
import Support

//*============================================================================*
// MARK: * Lexicon
//*============================================================================*

/// A mapping model between components and characters.
///
/// - Requires that each component is bidirectionally mapped to a character.
///
@usableFromInline struct Lexicon<Component: Unit> {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var components: [Character: Component]
    @usableFromInline var characters: [Component: Character]
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates an empty instance with reserved capacity, since mapping for all is reqiured..
    @inlinable init(count: Int) {
        self.components = [:]; self.components.reserveCapacity(count)
        self.characters = [:]; self.characters.reserveCapacity(count)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - All
    //=------------------------------------------------------------------------=

    @inlinable init(character: (Component) throws -> Character) rethrows where Component: Unit {
        let components = Component.allCases
        self.init(count: components.count)
        for component in components {
            try link(component, character(component))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    /// Creates a new object with bidirectional ASCII character-component links.
    @inlinable static func ascii() -> Self {
        Self(character: \.character)
    }
    
    @inlinable static func local(_ formatter: NumberFormatter) throws -> Self {
        try Self(character: { component in try component.character(formatter) })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Subscripts
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(character: Character) -> Component? {
        _read   { yield  components[character] }
        _modify { yield &components[character] }
    }
    
    /// Bidirectional mapping is required for all components, so characters may be force unwrapped.
    @inlinable subscript(component: Component) -> Character {
        _read   { yield  characters[component]! }
        _modify { yield &characters[component]! }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func link(_ component: Component, _ character: Character) {
        self.components[character] = component
        self.characters[component] = character
    }
}
