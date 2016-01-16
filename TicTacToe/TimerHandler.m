#import "TimerHandler.h"
#import <UIKit/UIKit.h>

@interface TimerHandler ()

@property double timeForKillerToKill;

@end

@implementation TimerHandler

-(void)buttonPushed {
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.tttvc.timeBetweenTurns target:self selector:@selector(timeIsUp) userInfo:nil repeats:NO];
    [self.displayTimer invalidate];
    [self.timerKiller invalidate];
    self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:self.tttvc.decrementSize target:self selector:@selector(updateTimerLabel) userInfo:nil repeats:YES];
    double whatever = self.tttvc.timeBetweenTurns - self.tttvc.decrementSize + 0.01;
    self.timerKiller = [NSTimer scheduledTimerWithTimeInterval:whatever target:self selector:@selector(killTimer) userInfo:nil repeats:NO];
}

- (void) timeIsUp {
    self.tttvc.timerLabelText = @"0.0";
    [self.displayTimer invalidate];
    [self.tttvc displayVictoryMessage:@"Time is up."
                          title:@"You lose."];
}

- (void) updateTimerLabel {
    double currentTime = [self.tttvc.timerLabelText doubleValue];
    double something = currentTime - self.tttvc.decrementSize;
    self.tttvc.timerLabelText = [NSString stringWithFormat:@"%.1f", something];
}

- (void) killTimer {
    [self.displayTimer invalidate];
}


@end
