//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Links
//*============================================================================*

/// A mapping model between components and characters.
///
/// It ensures that each component is bidirectionally mapped to a character.
///
@usableFromInline struct Links<Component: Unit> {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var components: [Character: Component]
    @usableFromInline private(set) var characters: [Component: Character]
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates an empty instance with reserved capacity equal to count.
    @inlinable init(count: Int) {
        self.components = [:]; self.components.reserveCapacity(count)
        self.characters = [:]; self.characters.reserveCapacity(count)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Indirect
    //=------------------------------------------------------------------------=

    /// Creates an instance linking all components to their corresponding character.
    @inlinable init(character: (Component) throws -> Character) rethrows {
        let components = Component.allCases
        self.init(count: components.count)
        for component in components {
            try link(component, character(component))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance with ASCII component-character links.
    @inlinable static func ascii() -> Self {
        Self(character: \.character)
    }
    
    /// Creates a new instance with localized standard component-character links.
    @inlinable static func standard(_ formatter: NumberFormatter) -> Self {
        Self(character: { $0.standard(formatter) })
    }
    
    /// Creates a new instance with localized currency component-character links.
    @inlinable static func currency(_ formatter: NumberFormatter) -> Self {
        Self(character: { $0.currency(formatter) })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Subscripts
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(character: Character) -> Component? {
        _read { yield components[character]  }
    }
    
    /// Bidirectional mapping is required for all components, so characters may be force unwrapped.
    @inlinable subscript(component: Component) -> Character {
        _read { yield characters[component]! }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func link(_ component: Component, _ character: Character) {
        self.components[character] = component
        self.characters[component] = character
    }
}
