//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

struct Field {
    let format: Format
    let selection: Selection
    
    // MARK: Initializers
        
    @inlinable init(format: Format, selection: Selection? = nil) {
        self.format = format
        self.selection = selection ?? Selection(format.carets)
    }
    
    // MARK: Updaters
    
    func updating(format newValue: Format) -> Field {
        Field(format: newValue, selection: selection.updating(carets: newValue.carets))
    }
    
    func updating(selection newValue: Selection) -> Field {
        Field(format: format, selection: newValue)
    }
}
