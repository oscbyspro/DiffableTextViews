//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Lexicon
//*============================================================================*

/// A mapping model between components and characters.
///
/// - Requires that each component is bidirectionally mapped to a character.
///
@usableFromInline struct Lexicon<Component: Hashable> {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var components: [Character: Component]
    @usableFromInline var characters: [Component: Character]
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(components: [Character: Component] = [:], characters: [Component: Character] = [:]) {
        self.components = components
        self.characters = characters
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Unicodeable
    //=------------------------------------------------------------------------=

    /// Creates a new object with bidirectional ASCII character-component links.
    @inlinable init(ascii: Component.Type) where Component: Unicodeable {
        let components = ascii.allCases; let count = components.count
        self.components = [:]; self.components.reserveCapacity(count)
        self.characters = [:]; self.characters.reserveCapacity(count)
        //=--------------------------------------=
        // MARK: Links
        //=--------------------------------------=
        for component in components {
            link(component.character, component)
        }
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
    
    @inlinable mutating func link(_ character: Character, _ component: Component) {
        self.components[character] = component
        self.characters[component] = character
    }
}
