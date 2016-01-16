#import <UIKit/UIKit.h>

@interface TicTacToeViewController : UIViewController

@property NSString *timerLabelText;
@property double timeBetweenTurns;
@property double decrementSize;

- (void) displayVictoryMessage:(NSString *)message title:(NSString *)title ;

@end

