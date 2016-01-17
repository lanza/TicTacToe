#import "Matrix.h"
#import <Foundation/Foundation.h>

@interface MatrixIterator : NSObject

@property Matrix *matrix;

- (BOOL)checkMatches;

- (instancetype)initWithMatrix:(Matrix *)matrix;

@end
