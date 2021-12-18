
1. Components should be split into: IntegerText and FloatingPointText. Both should conform to a new protocol called NumericText.
    - Make a new parser, maybe base it on sequence rather than collection to allow a LazySequence as input.
