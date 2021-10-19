//
//  NumberTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import SwiftUI
import struct Foundation.Locale

// MARK: - NumberTextStyle

#warning("FIXME: '1' cannot be deleted, that is one upper digit.")

@available(iOS 15.0, *)
public struct NumberTextStyle<Item: NumberTextStyleItem>: DiffableTextStyle {
    public typealias Value = Item.Number
    
    @usableFromInline typealias BasePrecision = NumberFormatStyleConfiguration.Precision
    @usableFromInline typealias BaseSeparator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    @usableFromInline typealias Components = NumberTextComponents

    public typealias Values = NumberTextValues<Item>
    public typealias Precision = NumberTextPrecision<Item>
    
    // MARK: Properties
    
    @usableFromInline var locale: Locale
    @usableFromInline var values: Values = .all
    @usableFromInline var precision: Precision = .max
        
    // MARK: Initializers
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.locale = locale
//        self.base = Base(locale: locale)
    }
    
    // MARK: Styles
    
    @inlinable func displayableStyle() -> Item.Style {
        let precision: BasePrecision = precision.displayableStyle()

        return Item.style(locale, precision: precision, separator: .automatic)
    }
    
    @inlinable func editableStyle(digits: (upper: Int, lower: Int)? = nil, separator: Bool = false) -> Item.Style {
        let precision: BasePrecision = precision.editableStyle(digits: digits)
        let separator: BaseSeparator = separator ? .always : .automatic
        
        return Item.style(locale, precision: precision, separator: separator)
    }
    
    // MARK: Maps
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        map({ $0.locale = locale })
    }
    
    @inlinable public func precision(_ newValue: Precision) -> Self {
        map({ $0.precision = newValue })
    }
    
    @inlinable public func values(_ newValue: Values) -> Self {
        map({ $0.values = newValue })
    }

    // MARK: Helpers
    
    @inlinable func map(_ transform: (inout Self) -> Void) -> Self {
        var copy = self; transform(&copy); return copy
    }
}

// MARK: DecimalTextStyle: Getters

@available(iOS 15.0, *)
extension NumberTextStyle {
    
    // MARK: Localization
    
    @inlinable var decimalSeparator: String {
        locale.decimalSeparator ?? "."
    }
    
    @inlinable var groupingSeparator: String {
        locale.groupingSeparator ?? ","
    }
    
    // MARK: Sets
  
    @inlinable func content() -> Set<Character> {
        var set = Set<Character>()
        set.formUnion(Components.minus)
        set.formUnion(Components.digits)
        set.formUnion(decimalSeparator)
        return set
    }
    
    @inlinable func spacers() -> Set<Character> {
        var set = Set<Character>()
        set.formUnion(groupingSeparator)
        return set
    }
}

// MARK: DecimalTextStyle: DiffableTextStyle

@available(iOS 15.0, *)
extension NumberTextStyle {
    
    // MARK: Snapshot
    
    @inlinable public func showcase(_ value: Value) -> Snapshot {
        let style = displayableStyle()
        
        return snapshot(style.format(value))
    }
    
    @inlinable public func snapshot(_ value: Value) -> Snapshot {
        let style = editableStyle()
        
        return snapshot(style.format(value))
    }
        
    // MARK: Value

    @inlinable public func parse(_ snapshot: Snapshot) -> Value? {
        guard let components = components(snapshot) else {
            return nil
        }
        
        guard let number = Item.number(components) else {
            return nil
        }

        return values.displayableStyle(number)
    }
    
    // MARK: Merge
    
    #warning("TODO")
    @inlinable public func merge(_ snapshot: Snapshot, with content: Snapshot, in bounds: Range<Snapshot.Index>) -> Snapshot? {
        #warning("WIP")
        var content = content
        var toggleSign = false
        
        if content.characters == Components.minus {
            content = Snapshot()
            toggleSign = true
        }
        
        let result = snapshot.replace(bounds, with: content)

        guard var components = components(result) else {
            return nil
        }

        if toggleSign {
            components.minus = components.minus.isEmpty ? Components.minus : String()
        }
        
        return self.snapshot(components)
    }
        
    // MARK: Helpers
    
    @inlinable func snapshot(_ components: Components) -> Snapshot? {
        
        // --------------------------------- //
        
        guard values.min < Item.zero || components.minus.isEmpty else {
            return nil
        }
        
        // --------------------------------- //
        
        let digits = (components.upper.count, components.lower.count)
        
        // --------------------------------- //
        
        guard precision.editableValidation(digits: digits) else {
            return nil
        }
        
        // --------------------------------- //
        
        guard let number = Item.number(components) else {
            return nil
        }
        
        guard values.editableValidation(number) else {
            // TODO: Should this check be here?
            return nil
        }
        
        // --------------------------------- //
        
        let style = editableStyle(digits: digits, separator: !components.separator.isEmpty)
                        
        var characters = style.format(number)
        
        if !components.minus.isEmpty, !characters.hasPrefix(components.minus) {
            characters = components.minus + characters
        }
                        
        // --------------------------------- //
        
        return snapshot(characters)
    }
    
    // MARK: Helpers
    
    @inlinable func components(_ snapshot: Snapshot) -> Components? {
        var characters = snapshot.content()
        characters = characters.replacingOccurrences(of: decimalSeparator, with: Components.separator)
        return Components(from: characters)
    }
    
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        var snapshot = Snapshot()
        
        let contentSet = content()
        let spacersSet = spacers()
        
        for character in characters {
            if contentSet.contains(character) {
                snapshot.append(.content(character))
            } else if spacersSet.contains(character) {
                snapshot.append(.spacer(character))
            }
        }
        
        return snapshot
    }
}
