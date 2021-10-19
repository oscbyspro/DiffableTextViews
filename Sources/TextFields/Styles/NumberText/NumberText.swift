//
//  NumberTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import SwiftUI
import struct Foundation.Locale

// MARK: - NumberTextStyle

#warning("FIXME: decimal separator now cuts zeros: 100.000 --> 100")

@available(iOS 15.0, *)
public struct NumberText<Base: NumberTextCompatible>: DiffableTextStyle {
    public typealias Item = Base.NumberTextItem
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
    
    @inlinable public func values(_ newValue: Values) -> Self {
        map({ $0.values = newValue })
    }
    
    @inlinable public func precision(_ newValue: Precision) -> Self {
        map({ $0.precision = newValue })
    }
    
    // MARK: Helpers
    
    @inlinable func map(_ transform: (inout Self) -> Void) -> Self {
        var copy = self; transform(&copy); return copy
    }
}

// MARK: DecimalTextStyle: DiffableTextStyle

@available(iOS 15.0, *)
extension NumberText {
    
    // MARK: Process
    
    @inlinable public func process(_ value: Value) -> Value {
        values.displayableStyle(value)
    }
    
    #warning("WIP")
    @inlinable public func process(_ snapshot: Snapshot) -> Snapshot {
        Snapshot("$ ", only: .prefix) + snapshot + Snapshot(" USD", only: .suffix)
    }
    
    // MARK: Snapshot
    
    @inlinable public func showcase(_ value: Value) -> Snapshot {
        let style = displayableStyle()
                
        return snapshot(style.format(value))
    }
    
    @inlinable public func snapshot(_ value: Value) -> Snapshot {
        let style = editableStyle()
        
        return snapshot(style.format(value))
    }
        
    // MARK: Parse

    @inlinable public func parse(_ snapshot: Snapshot) -> Value? {
        components(snapshot).flatMap(number)
    }
    
    // MARK: Merge
    
    @inlinable public func merge(_ snapshot: Snapshot, with replacement: Snapshot, in bounds: Range<Snapshot.Index>) -> Snapshot? {
        var replacement = replacement
        
        // --------------------------------- //
        
        let commands = Commands(input: &replacement)
                
        // --------------------------------- //
        
        let result = snapshot.replace(bounds, with: replacement)
        
        // --------------------------------- //
        
        guard var components = components(result) else {
            return nil
        }

        // --------------------------------- //
        
        commands.act(on: &components)
                
        // --------------------------------- //
        
        return self.snapshot(components)
    }
        
    // MARK: Helpers
    
    @inlinable func snapshot(_ components: Components) -> Snapshot? {
        
        // --------------------------------- //
        
        guard !values.nonnegative || components.minus.isEmpty else {
            return nil
        }
        
        // --------------------------------- //
        
        let digits = (components.upper.count, components.lower.count)
        
        // --------------------------------- //
        
        guard precision.editableValidation(digits: digits) else {
            return nil
        }
        
        // --------------------------------- //
        
        guard let number = number(components), values.editableValidation(number) else {
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
        characters = characters.replacingOccurrences(of: separator, with: Components.separator)
        return Components(from: characters)
    }
    
    @inlinable func number(_ components: Components) -> Value? {
        guard !components.hasNoDigits else {
            return Item.zero
        }
        
        return Item.number(components)
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
    
    // MARK: Commands
    
    @usableFromInline struct Commands {
        
        // MARK: Properties
        
        @usableFromInline var toggleSign: Bool = false
        
        // MARK: Initializers
        
        @inlinable init(input: inout Snapshot) {
            if input.characters == Components.minus {
                input.removeAll()
                toggleSign = true
            }
        }
        
        // MARK: Utilities
        
        @inlinable func act(on components: inout Components) {
            if toggleSign {
                components.toggleSign()
            }
        }
    }
}

// MARK: DecimalTextStyle: Getters

@available(iOS 15.0, *)
extension NumberText {
    
    // MARK: Localization
    
    @inlinable var separator: String {
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
        set.formUnion(separator)
        return set
    }
    
    @inlinable func spacers() -> Set<Character> {
        var set = Set<Character>()
        set.formUnion(groupingSeparator)
        return set
    }
}
