#import <Foundation/Foundation.h>
#import "Tile.h"
#import "TicTacToeViewController.h"

typedef enum {
    Row,
    Column,
    RightDiagonal,
    LeftDiagonal
} Change;

@interface Matrix : NSObject

@property NSMutableArray *buttonsArray;
@property NSMutableArray *matrix;
@property int dimension;

-(Tile *)tileAt:(int)index;
-(Tile *)tileAt:(int)first second:(int)second;

-(int)valueAt:(int)first second:(int)second;

- (instancetype)initWithDimension:(int)dimension;

- (NSMutableArray *)objectAtIndexedSubscript:(int)idx;

- (BOOL)doesElementMatchFor:(int)first second:(int)second change:(Change)change;

- (void)buttonSelected:(Tile *)button byPlayer:(SquareOwnership)player;

- (NSArray *)getRightDiagonal;
- (NSArray *)getLeftDiagonal;
- (NSArray *)getColumn:(int)index;
- (NSArray *)getRow:(int)index;

- (void) blankOutMatrix;

@end
