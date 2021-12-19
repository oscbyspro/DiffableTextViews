
1. Components should be split into: IntegerText and FloatingPointText. Both should conform to a new protocol called NumericText.

2. Reimagine: Boundable & Precise.
    - Precise.maxLosslessValue makes sense for integers, but not for floating points. 
    - Precise.maxLosslessDigits makes sense for floating points, but not for integers.
