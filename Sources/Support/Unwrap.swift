//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

infix operator ?!: NilCoalescingPrecedence

//=----------------------------------------------------------------------------=
// MARK: Unwrap or Throw
//=----------------------------------------------------------------------------=

@inlinable public func ?! <Value>(value: Value?, failure: @autoclosure () -> Error) throws -> Value {
    if let value = value { return value }; throw failure()
}
