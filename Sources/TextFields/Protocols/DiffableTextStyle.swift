//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

import SwiftUI

public protocol DiffableTextStyle {
    associatedtype Value: Equatable
    
    func snapshot(_ value: Value) -> Snapshot
    
    func parse(_ snapshot: Snapshot) -> Value?
        
    func merge(_ snapshot: Snapshot, with replacement: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot
}

extension DiffableTextStyle {
    // MARK: Defaults
    
    @inlinable func merge(_ snapshot: Snapshot, with replacement: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot {
        snapshot.replace(range, with: replacement)
    }
}
