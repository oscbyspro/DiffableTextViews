//
//  TODO.md
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//
    
1. Parse: .none when invalid, .some when valid, .some when partial.
    a) that means converting to value when and only when user input is valid (including partially complete).
    b) equality check prevents bad behavior when equality is unchanged, when "0" -> "0." both parse "0" for example.
    c) update with value on editing changed, such that "0." -> "0" when session ends.
    
2. Format: autocorrect when appropriate, ".1" -> "0.1" for example.
