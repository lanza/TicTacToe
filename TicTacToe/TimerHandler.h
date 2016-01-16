#import <Foundation/Foundation.h>
#import "TicTacToeViewController.h"

@interface TimerHandler : NSObject

@property TicTacToeViewController *tttvc;

@property NSTimer *timerKiller;
@property NSTimer *timer;
@property NSTimer *displayTimer;

-(void)buttonPushed;

@end
