#import "TimerHandler.h"
#import <UIKit/UIKit.h>

@interface TimerHandler ()

@property double timeForKillerToKill;

@end

@implementation TimerHandler

-(void)startNewTurnTimer {
    [self invalidateAllTimers];
    
    self.turnTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeBetweenTurns target:self selector:@selector(turnTimerEnded) userInfo:nil repeats:NO];
    self.labelUpdatingTimer = [NSTimer scheduledTimerWithTimeInterval:self.decrementSize target:self selector:@selector(decrementTimerLabel) userInfo:nil repeats:YES];
}

-(void)invalidateAllTimers {
    [self.turnTimer invalidate];
    NSLog(@"turnTimer has been invalidated: %@", self.turnTimer);
    [self.labelUpdatingTimer invalidate];
    NSLog(@"labelUpdatingTimer has been invalidated: %@",self.labelUpdatingTimer);
}


- (void) turnTimerEnded {
    NSLog(@"turnTimerEnded called");
    [self updateTimerLabeltoTime:0.0];
    [self.tttvc displayMessage:@"Time is up."
                          title:@"You lose."];
    
    [self invalidateAllTimers];
}

- (void) updateTimerLabeltoTime:(double)time {
    [self.tttvc newTimerLabelText:[NSString stringWithFormat:@"%f",time]];
}

- (void) decrementTimerLabel {
    double currentTime = [self.tttvc getCurrentTimeRemaining];
    double decrementedTime = currentTime - self.tttvc.decrementSize;
    [self updateTimerLabeltoTime:decrementedTime];
}



@end
