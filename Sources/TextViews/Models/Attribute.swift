//
//  Attribute.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-02.
//

// MARK: - Attribute

#warning("Make namespaces for composites/nonstandards.")
#warning("Rather than diffable, it should be removable, and insertible")
public struct Attribute: OptionSet {
    public static let editable   = Self(rawValue: 1 << 0) // flag for extraction
    public static let removable  = Self(rawValue: 1 << 1) // flag for ignore removal
    public static let insertable = Self(rawValue: 1 << 2) // flag for ignore insertion
    
    public static let forwards   = Self(rawValue: 1 << 3) // flag for movement (essentially prefix)
    public static let backwards  = Self(rawValue: 1 << 4) // flag for movement (essentially suffix)
    
    // MARK: Properties
    
    public let rawValue: UInt8
    
    // MARK: Initializers
        
    @inlinable public init(rawValue: UInt8 = 0) {
        self.rawValue = rawValue
    }
    
    // MARK: Composites
    
    public static let content: Self = [.editable]
    public static let spacer:  Self = [.removable, .insertable]
    public static let prefix:  Self = [.removable, .insertable,  .forwards]
    public static let suffix:  Self = [.removable, .insertable, .backwards]
}

#warning("OLD")

func lol() {
    #warning("...")
    let forces = "-><-"
}

public enum OLD_Attribute: Equatable {
    
    /// The `content` attribute makes it so the character `editable`.
    case content
    
    /// The `spacer` attribute makes it so the character is `noneditable` and the `cursor skips over it.`
    case spacer
    
    /// The `prefix` attribute makes it so the character is `noneditable` and the `cursor moves forwards from it.`
    case prefix
    
    /// The `suffix` attribute makes it so the character is `noneditable` and  the `cursor moves backwards from it.`
    case suffix
}
