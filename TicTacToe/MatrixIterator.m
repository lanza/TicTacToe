#import "MatrixIterator.h"

@interface MatrixIterator ()

@property int dimension;


@end

@implementation MatrixIterator

- (instancetype)initWithMatrix:(Matrix *)matrix {
    self = [super init];
    if (self) {
        self.matrix = matrix;
        self.dimension = matrix.dimension;
    }
    return self;
}


- (BOOL)checkMatches {
    BOOL doColumnsMatch = [self iterateColumns];
    BOOL doRowsMatch = [self iterateRows];
    BOOL doRowsAndColumnsRightMatch = [self iterateRightDiagonal];
    BOOL doRowsAndColumnsLeftMatch = [self iterateLeftDiagonal];
    NSLog(@":LKJSDF:LKSJFSKDJF:LSKFJSLDFKJ:LSDKJFSD:F");
    return (doRowsAndColumnsRightMatch || doColumnsMatch || doRowsMatch || doRowsAndColumnsLeftMatch);
}

- (BOOL)iterateColumns {
    NSMutableArray *columnBools = [NSMutableArray new];
    for (int column = 0; column <= self.dimension - 1; column++) {
        [columnBools addObject: @([self iterateOneColumn:column])];
    }
//    NSLog(@"%@",columnBools);
    return [columnBools containsObject:@(YES)];
}
- (BOOL)iterateOneColumn:(int)column {
    NSSet *elementSet = [NSSet setWithArray:[self.matrix getColumn:column]];
    return (elementSet.count == 1 && ([elementSet containsObject:@1] || [elementSet containsObject:@(2)]));
}

- (BOOL)iterateRows {
    NSMutableArray *rowBools = [NSMutableArray new];
    for (int row = 0; row <= self.dimension - 1; row++) {
        [rowBools addObject: @([self iterateOneRow:row])];
    }
//    NSLog(@"%@",rowBools);
    return [rowBools containsObject:@(YES)];
}
- (BOOL)iterateOneRow:(int)row{
    NSSet *elementSet = [NSSet setWithArray:[self.matrix getRow:row]];
    return (elementSet.count == 1 && ([elementSet containsObject:@1] || [elementSet containsObject:@(2)]));
}
- (BOOL)iterateRightDiagonal{
    NSSet *elementSet = [NSSet setWithArray:[self.matrix getRightDiagonal]];
    return (elementSet.count == 1 && ([elementSet containsObject:@1] || [elementSet containsObject:@(2)]));
}
- (BOOL)iterateLeftDiagonal {
    NSSet *elementSet = [NSSet setWithArray:[self.matrix getLeftDiagonal]];
    return (elementSet.count == 1 && ([elementSet containsObject:@1] || [elementSet containsObject:@(2)]));
}


@end
