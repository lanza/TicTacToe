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

@property int dimension;

- (void)setUpMatrix;

-(Tile *)tileAt:(int)index;

-(instancetype) initWithDimension:(int)dimension;


- (NSMutableArray *)objectAtIndexedSubscript:(int)idx;

- (NSArray *)getRightDiagonal;
- (NSArray *)getLeftDiagonal;
- (NSArray *)getColumn:(int)index;
- (NSArray *)getRow:(int)index;

- (void) blankOutMatrix;

@end
