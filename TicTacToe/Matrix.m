#import "TicTacToeViewController.h"
#import "Matrix.h"

@interface Matrix ()

@property NSMutableArray *matrix;

@end


@implementation Matrix

- (instancetype)initWithDimension:(int)dimension {
    self = [super init];
    if (self) {
        self.dimension = dimension;
        self.buttonsArray = [NSMutableArray new];
    }
    return self;
}

- (void)setUpMatrix {
    NSMutableArray *matrix = [NSMutableArray new];
    
    for (int i = 0; i < self.dimension; i++) {
        NSMutableArray *row = [NSMutableArray new];
        for (int j = 0; j < self.dimension; j++) {
            [row addObject:self.buttonsArray[i*self.dimension + j]];
        }
        [matrix addObject:row];
    }
    self.matrix = matrix;
}

- (NSMutableArray *)objectAtIndexedSubscript:(int)idx {
    return self.matrix[idx];
}

- (Tile *)tileAt:(int)index {
    
    return self.buttonsArray[index];
}


- (NSArray *)getRow:(int)index {
    NSMutableArray *row = [NSMutableArray new];
    for (int i = 0; i < self.dimension; i++) {
        [row addObject:(self.matrix[index][i])];
    }
    return row;
}

- (NSArray *)getColumn:(int)index {
    NSMutableArray *column = [NSMutableArray new];
    for (int i = 0; i < self.dimension; i++) {
        [column addObject:self.matrix[i][index]];
    }

    return column;
}

- (NSArray *)getRightDiagonal {
    NSMutableArray *rightDiagonal = [NSMutableArray new];
    for (int i = 0; i < self.dimension; i++) {
        [rightDiagonal addObject:self.matrix[i][i]];
    }
    return rightDiagonal;
}

- (NSArray *)getLeftDiagonal {
    NSMutableArray *leftDiagonal = [NSMutableArray new];
    for (int i = 0; i < self.dimension; i++) {
        [leftDiagonal addObject:self.matrix[i][self.dimension - 1 - i]];
    }
    return leftDiagonal;
}


- (void) blankOutMatrix {
    for (int i = 0; i < self.dimension; i++) {
        for (int j = 0; j < self.dimension; j++) {
            ((Tile *)self.matrix[i][j]).buttonOwner = 0;
        }
    }
}



@end