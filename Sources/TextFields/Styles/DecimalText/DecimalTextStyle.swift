//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-28.
//


#warning("Sign should be toggleable, and sign deletions should pass through prefixes.")
#warning("This means than range and replacement need to exposed, maybe.")

import SwiftUI

#if os(iOS)

@available(iOS 15.0, *)
public struct DecimalTextStyle: DiffableTextStyle {
    @usableFromInline typealias Base = Decimal.FormatStyle
    @usableFromInline typealias BasePrecisionStrategy = Base.Configuration.Precision
    @usableFromInline typealias BaseSeparatorStrategy = Base.Configuration.DecimalSeparatorDisplayStrategy
    @usableFromInline typealias Components = DecimalTextComponents

    public typealias Values = NumberTextValues<DecimalTextItem>
    public typealias Precision = NumberTextPrecision<DecimalTextItem>

    // MARK: Properties
    
    @usableFromInline var base: Base
    @usableFromInline var values: Values = .all
    @usableFromInline var precision: Precision = .max
        
    // MARK: Initializers
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.base = Base(locale: locale)
    }
    
    // MARK: Styles
    
    @inlinable func displayableStyle() -> Base {
        base.precision(precision.displayableStyle())
    }
    
    @inlinable func editableStyle(decimalSeparator: Bool = false, fractionLowerBound: Int? = nil) -> Base {
        base.precision(precision.editableStyle(integersLowerBound: 1, fractionLowerBound: fractionLowerBound))
            .decimalSeparator(strategy: decimalSeparator ? .always : .automatic)
    }
    
    // MARK: Maps
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        map({ $0.base = $0.base.locale(locale) })
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
extension DecimalTextStyle {
    
    // MARK: Localization
    
    @inlinable var locale: Locale {
        base.locale
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

// MARK: DecimalTextStyle: DiffableTextStyle

@available(iOS 15.0, *)
extension DecimalTextStyle {
    
    // MARK: Snapshot
        
    @inlinable public func showcase(_ value: Decimal) -> Snapshot {
        let style = displayableStyle()
        
        return snapshot(style.format(value))
    }
    
    @inlinable public func snapshot(_ value: Decimal) -> Snapshot {
        let style = editableStyle()
        
        return snapshot(style.format(value))
    }
        
    // MARK: Value

    @inlinable public func parse(_ snapshot: Snapshot) -> Decimal? {
        guard let components = components(snapshot) else {
            return nil
        }
        
        guard !components.isEmpty else {
            return .zero
        }
        
        return components.decimal()
    }
    
    @inlinable public func process(_ value: Decimal) -> Decimal {
        values.displayableStyle(value)
    }
    
    // MARK: Process
    
    @inlinable public func merge(_ snapshot: Snapshot, with content: Snapshot, in bounds: Range<Snapshot.Index>) -> Snapshot? {
        #warning("WIP")
        var content = content
        var toggleSign = false
        
        if content.characters == Components.sign {
            content = Snapshot()
            toggleSign = true
        }
        
        let result = snapshot.replace(bounds, with: content)

        guard var components = components(result) else {
            return nil
        }

        if toggleSign {
            components.sign = components.sign.isEmpty ? Components.sign : ""
        }
        
        return self.snapshot(components)
    }
    
    @inlinable func snapshot(_ components: Components) -> Snapshot? {
        guard values.min < .zero || components.sign.isEmpty else {
            return nil
        }
                
        if components.integerDigits.isEmpty, components.decimalSeparator.isEmpty, components.decimalDigits.isEmpty {
            return Snapshot(components.characters(), only: .content)
        }
                                
        guard precision.validate(editable: components) else {
            return nil
        }
        
        // style
        
        let style = editableStyle(decimalSeparator: !components.decimalSeparator.isEmpty, fractionLowerBound: components.decimalDigits.count)

        // decimal
        
        guard let decimal = components.decimal() else {
            return nil
        }
        
        guard values.editableValidation(decimal) else {
            return nil
        }
        
        // characters
        
        var characters = style.format(decimal)
        
        if !components.sign.isEmpty, !characters.hasPrefix(components.sign) {
            characters = components.sign + characters
        }
        
        // snapshot
        
        return snapshot(characters)
    }
    
    // MARK: Helpers
    
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
    
    @inlinable func components(_ snapshot: Snapshot) -> Components? {
        var characters = snapshot.content()
        characters = characters.replacingOccurrences(of: decimalSeparator, with: Components.decimalSeparator)
        return DecimalTextComponents(from: characters)
    }
}

#endif
