#import <Foundation/Foundation.h>
#import "TicTacToeViewController.h"

@interface TimerHandler : NSObject

@property (weak) TicTacToeViewController *tttvc;

@property NSTimer *timerKiller;
@property NSTimer *turnTimer;
@property NSTimer *labelUpdatingTimer;

@property double timeBetweenTurns;
@property double decrementSize;


-(void)startNewTurnTimer;

-(void)invalidateAllTimers;

@end
