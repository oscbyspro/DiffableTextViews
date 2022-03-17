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
@usableFromInline struct Links<Component: Glyph> {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var components: [Character: Component]
    @usableFromInline private(set) var characters: [Component: Character]
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
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
    
    @inlinable static func ascii() -> Self {
        Self(character: \.character)
    }
    
    @inlinable static func standard(_ formatter: NumberFormatter) -> Self {
        Self(character: { $0.standard(formatter) })
    }
    
    @inlinable static func currency(_ formatter: NumberFormatter) -> Self {
        Self(character: { $0.currency(formatter) })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(character: Character) -> Component? {
        _read { yield components[character] }
    }
    
    /// Bidirectional mapping is required for all components, so force unwrapping characters is OK.
    @inlinable subscript(component: Component) -> Character! {
        _read { yield characters[component] }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func link(_ component: Component, _ character: Character) {
        self.components[character] = component
        self.characters[component] = character
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func contains(_ character: Character) -> Bool {
        components[character] != nil
    }
    
    @inlinable func contains(_ component: Component) -> Bool {
        characters[component] != nil
    }
}
