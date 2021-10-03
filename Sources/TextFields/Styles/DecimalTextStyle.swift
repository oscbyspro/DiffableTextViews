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
    
//    var maximum: Decimal =  .greatestFiniteMagnitude
//    var minimum: Decimal = -.greatestFiniteMagnitude
    
    // MARK: Initialization
    
    @inlinable public init() {
        self.formatStyle = DecimalFormatStyle()
    }
    
    // MARK: Protocol: DiffableTextStyle
    
    public func snapshot(_ value: Decimal) -> Snapshot {
        var snapshot = Snapshot()
        
        let contentSet = formatStyle.content()
        let spacersSet = formatStyle.spacers()
        
        let characters = formatStyle.format(value)
        
        for character in characters {
            if contentSet.contains(character) {
                snapshot.append(.content(character))
                print(0)
            } else if spacersSet.contains(character) {
                snapshot.append(.spacer(character))
                print(1)
            }
        }
        
        return snapshot
    }
        
    public func parse(_ snapshot: Snapshot) -> Decimal? {
        guard !snapshot.content.isEmpty else {
            return 0
        }
        
        guard let decimal = try? Decimal(snapshot.content, strategy: formatStyle.parseStrategy) else {
            return nil
        }
        
        return decimal
    }
    
    public func autocorrect(_ snapshot: Snapshot) -> Snapshot {
        var result = snapshot
        
        separator: if let index = result.view(\.character).firstIndex(of: formatStyle.decimalSeparator) {
            guard index > result.startIndex else { break separator }
            
            let previousIndex = result.index(before: index)
            
            if !snapshot[previousIndex].character.isNumber {
                result.insert(.content(formatStyle.zero), at: index)
            }
        }
        
        print(result.content)
        
        return result
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
