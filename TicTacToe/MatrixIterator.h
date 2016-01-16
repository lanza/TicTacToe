
#import <Foundation/Foundation.h>

@interface MatrixIterator : NSObject

@property NSMutableArray *matrix;

- (NSMutableArray *)createMatrixWithRowsAndColumns:(int)rowsAndColumns;
- (BOOL)checkMatches;

@end
