//
//  NumberTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import SwiftUI
import struct Foundation.Locale

// MARK: - NumberTextStyle

@available(iOS 15.0, *)
public struct NumberText<Item: NumberTextItem>: DiffableTextStyle {
    public typealias Value = Item.Number
    public typealias Values = NumberTextValues<Item>
    public typealias Precision = NumberTextPrecision<Item>
    
    @usableFromInline typealias Components = NumberTextComponents
    @usableFromInline typealias PrecisionStyle = NumberFormatStyleConfiguration.Precision
    @usableFromInline typealias SeparatorStyle = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy

    // MARK: Properties
    
    @usableFromInline var locale: Locale
    @usableFromInline var values: Values = .all
    @usableFromInline var precision: Precision = .max
    
    @usableFromInline var prefix: String? = nil
    @usableFromInline var suffix: String? = nil
    
    // MARK: Initializers
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.locale = locale
    }
    
    // MARK: Styles
    
    @inlinable func displayableStyle() -> Item.Style {
        let precision: PrecisionStyle = precision.displayableStyle()

        return Item.style(locale, precision: precision, separator: .automatic)
    }
    
    @inlinable func editableStyle(digits: (upper: Int, lower: Int)? = nil, separator: Bool = false) -> Item.Style {
        let precision: PrecisionStyle = precision.editableStyle(digits: digits)
        let separator: SeparatorStyle = separator ? .always : .automatic
        
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
    
    @inlinable public func prefix(_ newValue: String?) -> Self {
        map({ $0.prefix = newValue })
    }
    
    @inlinable public func suffix(_ newValue: String?) -> Self {
        map({ $0.suffix = newValue })
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
    
    @inlinable public func process(_ snapshot: Snapshot) -> Snapshot {
        let prefix = prefix.map({ Snapshot($0 + " ", only: .prefix) }) ?? Snapshot()
        let suffix = suffix.map({ Snapshot(" " + $0, only: .suffix) }) ?? Snapshot()
    
        return prefix + snapshot + suffix
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
    
    @inlinable public func merge(_ snapshot: Snapshot, with replacement: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot? {
        var replacement = replacement
        
        // --------------------------------- //
        
        let commands = Commands(input: &replacement)
                
        // --------------------------------- //
        
        let result = snapshot.replace(range, with: replacement)
        
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
