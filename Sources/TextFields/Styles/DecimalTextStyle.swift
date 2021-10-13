//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-28.
//

#if os(iOS)

import SwiftUI

@available(iOS 15.0, *)
public struct DecimalTextStyle: DiffableTextStyle {
    @usableFromInline let formatStyle: DecimalFormatStyle
    
    // MARK: Initialization
    
    @inlinable public init() {
        self.formatStyle = DecimalFormatStyle()
    }
    
    // MARK: Protocol: DiffableTextStyle
    
    public func format(_ value: Decimal) -> Layout {
        var snapshot = Layout()
        
        let characters = formatStyle.format(value)
        let contentSet = formatStyle.content()
        let spacersSet = formatStyle.spacers()
        
        for character in characters {
            if contentSet.contains(character) {
                snapshot.append(.content(character))
            } else if spacersSet.contains(character) {
                snapshot.append(.spacer(character))
            }
        }
        
        return snapshot
    }
        
    public func parse(_ snapshot: Layout) -> Decimal? {
        let content = snapshot.content()
        
        guard !content.isEmpty else {
            return 0
        }
        
        guard let decimal = Decimal(string: content, locale: formatStyle.locale) else {
            return nil
        }
        
        return decimal
    }
    
    public func accept(_ layout: Layout) -> Layout? {
        guard let decimal = parse(layout) else { return nil }
        
        return format(decimal)
    }
}

// MARK: -

@available(iOS 15.0, *)
@usableFromInline struct DecimalFormatStyle: ParseableFormatStyle {
    @usableFromInline let wrapped: Decimal.FormatStyle
        
    @inlinable init() {
        self.wrapped = Decimal.FormatStyle(locale: .autoupdatingCurrent)
            .grouping(.automatic)
            .decimalSeparator(strategy: .automatic)
            .precision(.significantDigits(0 ... 38))
    }
    
    // MARK: Protocol: FormatStyle
    
    @inlinable func format(_ value: Decimal) -> String {
        wrapped.format(value)
    }
    
    // MARK: Protocol: ParseableFormatStyle
    
    @inlinable var parseStrategy: Decimal.ParseStrategy<Decimal.FormatStyle> {
        wrapped.parseStrategy
    }
    
    // MARK: Getters
    
    @inlinable var locale: Locale {
        wrapped.locale
    }
    
    @inlinable var signs: String {
        "+-"
    }
    
    @inlinable var digits: String {
        "0123456789"
    }
    
    @inlinable var decimalSeparator: Character {
        locale.decimalSeparator.map(Character.init) ?? "."
    }
    
    @inlinable var groupingSeparator: Character {
        locale.groupingSeparator.map(Character.init) ?? ","
    }
    
    @inlinable var zero: Character {
        "0"
    }
    
    // MARK: CharacterSets
    
    @inlinable func content() -> Set<Character> {
        var set = Set<Character>()
        set.formUnion(signs)
        set.formUnion(digits)
        set.insert(decimalSeparator)
        return set
    }
    
    @inlinable func spacers() -> Set<Character> {
        var set = Set<Character>()
        set.insert(groupingSeparator)
        return set
    }
}

#endif
