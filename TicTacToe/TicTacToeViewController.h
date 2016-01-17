#import <UIKit/UIKit.h>

//const int playerNumber = 1;
//const int computerNumber = -1;
//const int blankNumber = 0;

typedef enum {
    User = 1,
    Computer = 2,
    Blank = 0
} SquareOwnership;


@interface TicTacToeViewController : UIViewController

@property NSString *timerLabelText;
@property double timeBetweenTurns;
@property double decrementSize;
@property int dimension;

- (void) displayMessage:(NSString *)message title:(NSString *)title ;

@end

