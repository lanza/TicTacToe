#import "MatrixIterator.h"

@interface MatrixIterator ()

@property int columns;


@end

@implementation MatrixIterator

- (NSMutableArray *)createMatrixWithRowsAndColumns:(int)rowsAndColumns {
    NSMutableArray *columns = [NSMutableArray new];
    
    for (int i = 0; i < rowsAndColumns; i++) {
        NSMutableArray *row = [NSMutableArray new];
        for (int j = 0; j < rowsAndColumns; j++) {
            [row addObject:[NSNumber numberWithInt:5]];
        }
        [columns addObject:row];
    }
    self.columns = rowsAndColumns;
    self.matrix = columns;
    return columns;
}

- (BOOL)checkMatches {
    BOOL doColumnsMatch = YES;
    BOOL doRowsMatch = YES;
    BOOL doRowsAndColumnsRightMatch = YES;
    BOOL doRowsAndColumnsLeftMatch = YES;
    
    NSMutableArray *columnBools = [NSMutableArray new];
    for (int row = 0; row <= self.columns - 1; row++) {
        [columnBools addObject: @([self columnIteration:row])];
    }
    NSMutableArray *rowBools = [NSMutableArray new];
    for (int column = 0; column <= self.columns - 1; column++) {
        [rowBools addObject: @([self rowIteration:column])];
    }
    doRowsAndColumnsRightMatch = [self columnAndRowIterationRight];
    doRowsAndColumnsLeftMatch = [self columnAndRowIterationLeft];
    
    doRowsMatch = [rowBools containsObject:@(YES)];
    doColumnsMatch = [columnBools containsObject:@(YES)];
    
    if (doRowsAndColumnsRightMatch || doColumnsMatch || doRowsMatch || doRowsAndColumnsLeftMatch) {
        return YES;
    } else {
        return NO;
    }
    
}


- (BOOL)checkBoolArray:(NSMutableArray *)bools {
  
    NSSet *boolSet = [NSSet setWithArray:bools];
    
    if (boolSet.count == 1 && [boolSet containsObject:@(YES)]) {
        return YES;
    }
    return NO;
}

- (BOOL)columnIteration:(int)row {
    NSMutableArray *bools = [NSMutableArray new];
    for (int toIncrement = 0; toIncrement < (self.columns - 1); toIncrement++) {
        if (self.matrix[row][toIncrement] == self.matrix[row][1+toIncrement] && [self.matrix[row][toIncrement] intValue] != 5) {
            [bools addObject:@(YES)];
        } else {
            [bools addObject:@(NO)];
        }
    }
    return [self checkBoolArray:bools];
}

- (BOOL)rowIteration:(int)column {
    NSMutableArray *bools = [NSMutableArray new];
    for (int toIncrement = 0; toIncrement < (self.columns - 1); toIncrement++) {
        if (self.matrix[toIncrement][column] == self.matrix[toIncrement+1][column] && [self.matrix[toIncrement][column] intValue] != 5) {
            [bools addObject:@(YES)];
        } else {
            [bools addObject:@(NO)];
        }
    }
    return [self checkBoolArray:bools];
}

- (BOOL)columnAndRowIterationRight {
    NSMutableArray *bools = [NSMutableArray new];
    for (int toIncrement = 0; toIncrement < (self.columns - 1); toIncrement++) {
        if (self.matrix[toIncrement][toIncrement] == self.matrix[toIncrement+1][toIncrement+1] && [self.matrix[toIncrement][toIncrement] intValue] != 5) {
            [bools addObject:@(YES)];
        } else {
            [bools addObject:@(NO)];
        }
    }
    return [self checkBoolArray:bools];
}
- (BOOL)columnAndRowIterationLeft {
    NSMutableArray *bools = [NSMutableArray new];
    for (int toIncrement = 0; toIncrement < (self.columns - 1); toIncrement++) {
        if (self.matrix[toIncrement][self.columns - 1 - toIncrement] == self.matrix[toIncrement+1][self.columns - 2 - toIncrement] && [self.matrix[toIncrement][self.columns - 1 - toIncrement] intValue] != 5) {
            [bools addObject:@(YES)];
        } else {
            [bools addObject:@(NO)];
        }
    }
    return [self checkBoolArray:bools];
}


@end
