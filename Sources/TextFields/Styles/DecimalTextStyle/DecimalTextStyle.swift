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
    @usableFromInline typealias Wrapped = Decimal.FormatStyle
    @usableFromInline typealias Components = DecimalTextComponents
    
    // MARK: Properties
    
    @usableFromInline let wrapped: Wrapped
        
    // MARK: Initializers
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.wrapped = Decimal.FormatStyle(locale: locale)
            .grouping(.automatic)
            .decimalSeparator(strategy: .automatic)
            .precision(.significantDigits(0 ... 38))
    }
    
    // MARK: Getters
    
    @inlinable var locale: Locale {
        wrapped.locale
    }
    
    @inlinable var decimalSeparator: String {
        locale.decimalSeparator ?? "."
    }
    
    @inlinable var groupingSeparator: String {
        locale.groupingSeparator ?? ","
    }
    
    // MARK: Sets
    
    @inlinable func content() -> Set<Character> {
        var set = Set<Character>()
        set.formUnion(Components.sign)
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

// MARK: - DiffableTextStyle

@available(iOS 15.0, *)
extension DecimalTextStyle {
    
    // MARK: Format
    
    public func format(_ value: Decimal) -> Snapshot {
        snapshot(from: wrapped.format(value))
    }
        
    // MARK: Parse

    public func parse(_ snapshot: Snapshot) -> Decimal? {
        guard !snapshot.isEmpty else {
            return 0
        }
                        
        guard let decimal = try? Decimal(snapshot.characters, strategy: wrapped.parseStrategy) else {
            return nil
        }
                
        return decimal
    }
    
    // MARK: Accept
        
    public func accept(_ snapshot: Snapshot) -> Snapshot? {
        guard var components = components(from: snapshot) else { return nil }

        // edge cases
                
        if !components.decimalSeparator.isEmpty, components.integerDigits.isEmpty {
            components.integerDigits = Components.zero
        }
        
        if components.integerDigits.isEmpty, components.decimalSeparator.isEmpty, components.decimalDigits.isEmpty  {
            return Snapshot(components.characters(), only: .content)
        }
        
        // parse
        
        guard let decimal = parse(snapshot) else {
            return nil
        }
        
        // style
        
        var style = wrapped
        
        if !components.decimalSeparator.isEmpty {
            style = wrapped.decimalSeparator(strategy: .always)
        }
        
        // format
        
        var characters = style.format(decimal)
        
        if !components.sign.isEmpty && !characters.hasPrefix(components.sign) {
            characters = components.sign + characters
        }
        
        // return
        
        return self.snapshot(from: characters)
    }
    
    // MARK: Helpers
    
    @inlinable func components(from snapshot: Snapshot) -> Components? {
        var characters = snapshot.content()
        characters = characters.replacingOccurrences(of: decimalSeparator, with: Components.decimalSeparator)
        return DecimalTextComponents(from: characters)
    }
    
    @inlinable func snapshot(from characters: String) -> Snapshot {
        var snapshot = Snapshot()
        
        let contentSet = content()
        let spacersSet = spacers()
        
        for character in characters {
            if contentSet.contains(character) {
                snapshot.append(.content(character))
            } else if spacersSet.contains(character) {
                snapshot.append( .spacer(character))
            }
        }
        
        return snapshot
    }
}

#endif
