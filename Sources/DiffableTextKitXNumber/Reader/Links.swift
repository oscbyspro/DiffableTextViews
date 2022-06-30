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
@usableFromInline struct Links<Component: Glyph> {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var components: [Character: Component]
    @usableFromInline private(set) var characters: [Component: Character]
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Links each component to a character.
    @inlinable init(character: (Component) throws -> Character) rethrows {
        let components = Component.allCases; let count = components.count
        //=--------------------------------------=
        // Count
        //=--------------------------------------=
        self.components = .init(minimumCapacity: count)
        self.characters = .init(minimumCapacity: count)
        //=--------------------------------------=
        // Links
        //=--------------------------------------=
        for component in components {
            try link(component, character(component))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
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
    
    /// All components map to a character, it it's OK.
    @inlinable subscript(component: Component) -> Character {
        characters[component]!
    }
    
    @inlinable subscript(character: Character) -> Component? {
        components[character]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func link( _ component: Component, _ character: Character) {
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
