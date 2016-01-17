#import "ComputerAI.h"
typedef enum {
    Win = 2,
    Block = 1
} Outcome;

@interface ComputerAI ()

@end

@implementation ComputerAI

- (Tile *)whereShouldComputerPlay {
    Tile *tileToPlayAt = [self tryToBlockOrWin:Win];
    if (tileToPlayAt != nil) {
        return tileToPlayAt;
    }
    
    tileToPlayAt = [self tryToBlockOrWin:Block];
    if (tileToPlayAt != nil) {
        return tileToPlayAt;
    }
    return [self generateRandomTile];
    
}

- (Tile *)generateRandomTile {;
    int randomNumber = arc4random_uniform((self.dimension * self.dimension) - 1);
    Tile *randomTile = [self.matrix tileAt:randomNumber];
    
    if (randomTile.buttonOwner == 0) {
        return randomTile;
    } else {
        return [self generateRandomTile];
    }
}

- (NSMutableArray *)collectArrays {
    
    NSMutableArray *lines = [NSMutableArray new];
    
    for (int i = 0; i < self.dimension; i++) {
        [lines addObject:[self.matrix getColumn:i]];
        [lines addObject:[self.matrix getRow:i]];
    }
    
    [lines addObject:[self.matrix getLeftDiagonal]];
    [lines addObject:[self.matrix getRightDiagonal]];
    
    return lines;
}

- (Tile *)tryToBlockOrWin:(Outcome)goal {
    NSMutableArray *lines = [self collectArrays];
    
    for (int i = self.dimension - 1; i >= 0; i--) {
        for (NSMutableArray  *line in lines) {
            Tile *tile = [self checkLine:line to:Win atMatchesCount:i];
            if (tile != nil) { return tile; }
            tile = [self checkLine:line to:Block atMatchesCount:i];
            if (tile != nil) { return tile; }
        }
    }
    return nil;
}


- (Tile *)checkLine:(NSMutableArray *)line to:(Outcome)goal atMatchesCount:(int)count {
    int countOfMatches = 0;
    int countOfOpposites = 0;
    int countOfBlanks = 0;
    
    int oppositeOfGoal = 0;
    if (goal == 2) {
        oppositeOfGoal = 1;
    } else {
        oppositeOfGoal = 2;
    }
    
    for (Tile *tile in line) {
        if (tile.buttonOwner == goal) {
            countOfMatches++;
        } else if (tile.buttonOwner == oppositeOfGoal) {
            countOfOpposites++;
        }
    }
    
    countOfBlanks = line.count - countOfMatches - countOfOpposites;
    
    if (countOfMatches == count && countOfOpposites < 1) {
        for (Tile *tile in line) {
            if (tile.buttonOwner == 0) {
                return tile;
            }
        }
    }
    return nil;
}

@end
