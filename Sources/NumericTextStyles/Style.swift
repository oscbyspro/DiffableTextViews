//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import Foundation
import Support

//*============================================================================*
// MARK: * NumericTextStyle
//*============================================================================*

public struct NumericTextStyle<Format: NumericTextFormat>: DiffableTextStyle {
    public typealias Value = Format.FormatInput
    public typealias Bounds = NumericTextStyles.Bounds<Value>
    public typealias Precision = NumericTextStyles.Precision<Value>
    @usableFromInline typealias Adapter = NumericTextStyles.Adapter<Format>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var adapter: Adapter
    @usableFromInline var bounds: Bounds
    @usableFromInline var precision: Precision
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ format: Format) {
        self.adapter = Adapter(format)
        self.bounds = Bounds()
        self.precision = Precision()
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var format: Format {
        adapter.format
    }
    
    @inlinable var lexicon: Lexicon {
        adapter.translation.lexicon
    }

    @inlinable var translation: Translation {
        adapter.translation
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        var result = self; result.adapter.update(locale); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.adapter == rhs.adapter
        && lhs.bounds == rhs.bounds
        && lhs.precision == rhs.precision
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Upstream
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Format
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(_ value: Value) -> String {
        format.precision(precision.inactive()).format(value)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Upstream
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Interpret
    //=------------------------------------------------------------------------=
    
    @inlinable public func interpret(_ value: Value) -> Commit<Value> {
        var style = format.precision(precision.active())
        var value = value
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&value)
        //=--------------------------------------=
        // MARK: Value -> Components
        //=--------------------------------------=
        let formatted = style.format(value)
        let parseable = snapshot(formatted)
        var components = try! components(parseable)
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&components)
        precision.autocorrect(&components)
        //=--------------------------------------=
        // MARK: Value <- Components
        //=--------------------------------------=
        value = try! self.value(components)
        //=--------------------------------------=
        // MARK: Style
        //=--------------------------------------=
        style = style.sign(self.sign(components))
        //=--------------------------------------=
        // MARK: Commit
        //=--------------------------------------=
        return self.commit(value, components, style)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Downstream
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Merge
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge(_ changes: Changes) throws -> Commit<Value> {
        //=--------------------------------------=
        // MARK: Reader
        //=--------------------------------------=
        var reader = Reader(changes, lexicon)
        reader.translateSingleCharacterInput()
        let sign = reader.consumeSingleSignInput()
        let proposal = reader.changes.proposal()
        //=--------------------------------------=
        // MARK: Components
        //=--------------------------------------=
        var components = try components(proposal)
        components.set(optional:  sign)
        try bounds.validate(components)
        //=--------------------------------------=
        // MARK: Components - Count, Capacity
        //=--------------------------------------=
        let count = components.count()
        let capacity = try precision.capacity(count)
        components.removeSeparatorAsSuffixAtZeroCapacity(capacity)
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        let value = try self.value(components)
        try bounds.validate(value, components)
        //=--------------------------------------=
        // MARK: Style
        //=--------------------------------------=
        let style = format.precision(self.precision.interactive(count))
        .separator(self.separator(components)).sign(self.sign(components))
        //=--------------------------------------=
        // MARK: Commit
        //=--------------------------------------=
        return self.commit(value, components, style)
    }
}
