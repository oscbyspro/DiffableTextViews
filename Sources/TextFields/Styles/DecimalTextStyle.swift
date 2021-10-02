//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-28.
//

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
    
    #warning("Bad name: this should not format.")
    public func format(_ value: Decimal) -> String {
        value.formatted(.number.grouping(.never))
    }
    
    #warning("This shold simply convert content.")
    public func parse(_ content: String) -> Decimal? {
        guard !content.isEmpty else { return .zero }
        
        print(content)
        
        guard let value = Decimal(string: content.replacingOccurrences(of: ",", with: ".")) else { return nil }
        
//        #warning("There should be no need to unformat becaues there should be no format to unformat.")
//        guard let value = try? Decimal(content, strategy: formatStyle.parseStrategy) else { return nil }
        
        print(value)
        
//        guard minimum <= value, value <= maximum else { return nil }
                
        return value
    }
    
    
    public func snapshot(_ content: String) -> Snapshot {
        var snapshot = Snapshot()
        
        guard !content.isEmpty else { return snapshot }
        
        guard let decimal = parse(content) else { return snapshot }
        
        let content = format(decimal)
        
        let contentSet = formatStyle.content()
        let spacersSet = formatStyle.spacers()
        
        var remainders = content[...]
        
        if let first = remainders.first, formatStyle.signs.contains(first) {
            snapshot.append(.content(first))
            remainders.removeFirst()
        }
        
        print(remainders)
        
        if let first = remainders.first, first == formatStyle.decimalSeparator {
            snapshot.append(.content(formatStyle.zero))
            print(999)
        }
        
        for character in remainders {
            if contentSet.contains(character) {
                snapshot.append(.content(character))
            } else if spacersSet.contains(character) {
                snapshot.append(.content(character))
            }
        }
        
        return snapshot
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
