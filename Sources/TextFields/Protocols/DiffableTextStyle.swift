//
//  DiffableTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-23.
//

public protocol DiffableTextStyle: TextStyle {
    #warning("Document show snapshots should be created.")
    func snapshot(content: String) -> Snapshot
}
