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
// MARK: * Optional
//*============================================================================*

public struct _OptionalNumberTextStyle<Format: NumberTextFormat>: NumberTextStyleProtocol, WrapperTextStyle {
    public typealias Style = _NumberTextStyle<Format>
    public typealias Adapter = NumberTextAdapter<Format>
    public typealias Value = Optional<Format.FormatInput>
    public typealias Cache = Style.Cache

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var style: Style
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(_ format: Format) {
        self.style = Style(format)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always)
    public var adapter: Adapter {
        get { style.adapter }
        set { style.adapter = newValue }
    }
    
    @inlinable @inline(__always)
    public var bounds: Bounds {
        get { style.bounds }
        set { style.bounds = newValue }
    }
    
    @inlinable @inline(__always)
    public var precision: Precision {
        get { style.precision }
        set { style.precision = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension _OptionalNumberTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Inactive
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(_ value: Value, with cache: inout Cache) -> String {
        value.map(style.format) ?? String()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Active
    //=------------------------------------------------------------------------=
    
    @inlinable public func interpret(_ value: Value, with cache: inout Cache) -> Commit<Value> {
        value.map({ Commit.init(style.interpret($0)) }) ?? Commit()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Interactive
    //=------------------------------------------------------------------------=
    
    @inlinable public func resolve(_ proposal: Proposal, with cache: inout Cache) throws -> Commit<Value> {
        try number(proposal).map({ try Commit(style.resolve($0)) }) ?? Commit()
    }
}
