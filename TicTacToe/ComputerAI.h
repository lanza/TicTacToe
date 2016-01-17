#import <Foundation/Foundation.h>
#import "Matrix.h"

@interface ComputerAI : NSObject

@property Matrix *matrix;

- (Tile *)whereShouldComputerPlay;
@property int dimension;

@end
