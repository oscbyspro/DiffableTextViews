//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-14.
//

#warning("Ideas.")

protocol Caret {
    
    var preference: Direction { get }
    
    func validate() -> Bool { }
    
    func fall() -> Carets.Index?
    
    func climb() -> Carets.Index?
}
