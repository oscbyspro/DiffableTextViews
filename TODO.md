//
//  TODO.md
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

1. Consider maintaining a 'var content: String' property in Snapshot for performance reasons.
    a) Selection might also become faster if each index is also tied to a specific location in content.
    
2. Figure out where validation should occur and who's responsibility it is.

Later: Move FormatScheme to a separate module when you have decided how it should work.
