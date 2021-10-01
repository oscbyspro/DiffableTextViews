//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-23.
//

public protocol DiffableTextStyle: TextStyle {
    #warning("Doccument show snapshots should be created.")
    func snapshot(content: String) -> Snapshot
}
