//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * NumericTextStyle
//*============================================================================*

public struct _NumericTextStyle<Format: NumericTextFormat>: DiffableTextStyle {
    @usableFromInline typealias Adapter = DiffableTextStylesXNumeric.Adapter<Format>
    public typealias Bounds = DiffableTextStylesXNumeric.Bounds<Value>
    public typealias Precision = DiffableTextStylesXNumeric.Precision<Value>
    public typealias Value = Format.FormatInput

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
        adapter.format.rounded(.towardZero)
    }

    @inlinable var scheme: Scheme {
        adapter.scheme
    }
    
    @inlinable var lexicon: Lexicon {
        adapter.scheme.lexicon
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        var result = self; result.adapter = result.adapter.locale(locale); return result
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
        let style = format.precision(precision.active())
        var value = value
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&value)
        //=--------------------------------------=
        // MARK: Value -> Number
        //=--------------------------------------=
        let formatted = style.format(value)
        let parseable = snapshot(formatted)
        var number = try! number(parseable)
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&number)
        precision.autocorrect(&number)
        //=--------------------------------------=
        // MARK: Value <- Number
        //=--------------------------------------=
        value = try! self.value(number)
        //=--------------------------------------=
        // MARK: Commit
        //=--------------------------------------=
        return self.commit(value, number, style)
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
        var reader = Reader(changes, lexicon)
        reader.translateSingleCharacterInput()
        let sign = reader.consumeSingleSignInput()
        let proposal = reader.changes.proposal()
        //=--------------------------------------=
        // MARK: Input -> Number
        //=--------------------------------------=
        var number = try number(proposal)
        sign.map({ sign in number.sign = sign })
        //=--------------------------------------=
        // MARK: Autovalidate
        //=--------------------------------------=
        try bounds.autovalidate(number)
        let count = number.count()
        try precision.autovalidate(&number, count)
        //=--------------------------------------=
        // MARK: Value <- Number
        //=--------------------------------------=
        let value = try self.value(number)
        //=--------------------------------------=
        // MARK: Autovalidate
        //=--------------------------------------=
        try bounds.autovalidate(value, &number)
        //=--------------------------------------=
        // MARK: Commit
        //=--------------------------------------=
        let style = format.precision(precision.interactive(count))
        return self.commit(value, number, style)
    }
}