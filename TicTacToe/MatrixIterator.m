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
    return (doRowsAndColumnsRightMatch || doColumnsMatch || doRowsMatch || doRowsAndColumnsLeftMatch);
}

- (BOOL)iterateColumns {
    NSMutableArray *columnBools = [NSMutableArray new];
    for (int column = 0; column <= self.dimension - 1; column++) {
        [columnBools addObject: @([self iterateOneColumn:column])];
    }
    return [columnBools containsObject:@(YES)];
}
- (BOOL)iterateOneColumn:(int)column {
    NSMutableSet *elementSet = [NSMutableSet new];
    for (Tile *tile in [self.matrix getColumn:column]) {
        [elementSet addObject:@(tile.buttonOwner)];
    }

    return (elementSet.count == 1 && ([elementSet containsObject:@1] || [elementSet containsObject:@(2)]));
}

- (BOOL)iterateRows {
    NSMutableArray *rowBools = [NSMutableArray new];
    for (int row = 0; row <= self.dimension - 1; row++) {
        [rowBools addObject: @([self iterateOneRow:row])];
    }
    return [rowBools containsObject:@(YES)];
}
- (BOOL)iterateOneRow:(int)row{
    NSMutableSet *elementSet = [NSMutableSet new];
    for (Tile *tile in [self.matrix getRow:row]) {
        [elementSet addObject:@(tile.buttonOwner)];
    }    return (elementSet.count == 1 && ([elementSet containsObject:@1] || [elementSet containsObject:@(2)]));
}
- (BOOL)iterateRightDiagonal{
    NSMutableSet *elementSet = [NSMutableSet new];
    for (Tile *tile in [self.matrix getRightDiagonal]) {
        [elementSet addObject:@(tile.buttonOwner)];
    }
    return (elementSet.count == 1 && ([elementSet containsObject:@1] || [elementSet containsObject:@(2)]));
}
- (BOOL)iterateLeftDiagonal {
    NSMutableSet *elementSet = [NSMutableSet new];
    for (Tile *tile in [self.matrix getLeftDiagonal]) {
        [elementSet addObject:@(tile.buttonOwner)];
    }
    return (elementSet.count == 1 && ([elementSet containsObject:@1] || [elementSet containsObject:@(2)]));
}


@end
