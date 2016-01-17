#import "TicTacToeViewController.h"
#import "Matrix.h"


@implementation Matrix

- (instancetype)initWithDimension:(int)dimension
{
    self = [super init];
    if (self) {
        NSMutableArray *matrix = [NSMutableArray new];
        
        for (int i = 0; i < dimension; i++) {
            NSMutableArray *row = [NSMutableArray new];
            for (int j = 0; j < dimension; j++) {
                [row addObject:[NSNumber numberWithInt:0]];
            }
            [matrix addObject:row];
        }
        self.dimension = dimension;
        self.matrix = matrix;
        self.buttonsArray = [NSMutableArray new];
    }
    return self;
}

- (NSMutableArray *)objectAtIndexedSubscript:(int)idx {
    return self.matrix[idx];
}

- (Tile *)tileAt:(int)index {
    return self.buttonsArray[index];
}

-  (Tile *)tileAt:(int)first second:(int)second {
    return self.buttonsArray[first * self.dimension + second];
}

- (int)valueAt:(int)first second:(int)second {
    return [self.matrix[first][second] intValue];
}

- (void)buttonSelected:(Tile *)button byPlayer:(SquareOwnership)player {
    switch (player) {
        case User:
            self.matrix[button.firstIndex][button.secondIndex] = @(1);
            break;
        case Computer:
            self.matrix[button.firstIndex][button.secondIndex] = @(2);
            break;
        case Blank:
            assert(1);
            break;
    }
}


- (NSArray *)getRow:(int)index {
    NSMutableArray *row = [NSMutableArray new];
    for (int i = 0; i < self.dimension; i++) {
        [row addObject:(self.matrix[index][i])];
    }
    NSLog(@"row %@",row);
    return row;
}

- (NSArray *)getColumn:(int)index {
    NSMutableArray *column = [NSMutableArray new];
    for (int i = 0; i < self.dimension; i++) {
        [column addObject:self.matrix[i][index]];
    }
    NSLog(@"column %@",column);
    return column;
}

- (NSArray *)getRightDiagonal {
    NSMutableArray *rightDiagonal = [NSMutableArray new];
    for (int i = 0; i < self.dimension; i++) {
        [rightDiagonal addObject:self.matrix[i][i]];
    }
    NSLog(@"right diagonal %@",rightDiagonal);
    return rightDiagonal;
}

- (NSArray *)getLeftDiagonal {
    NSMutableArray *leftDiagonal = [NSMutableArray new];
        for (int i = 0; i < self.dimension; i++) {
            [leftDiagonal addObject:self.matrix[i][self.dimension - 1 - i]];
        }
    NSLog(@"left diagonal %@",leftDiagonal);
    return leftDiagonal;
}


- (void) blankOutMatrix {
    for (int i = 0; i < self.dimension; i++) {
        for (int j = 0; j < self.dimension; j++) {
            self.matrix[i][j] = @0;
        }
    }
}



@end