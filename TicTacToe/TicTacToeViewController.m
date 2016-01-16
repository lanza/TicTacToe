#import "TicTacToeViewController.h"
#import "MatrixIterator.h"
#import <NLWebView/NLWebView.h>
#import "TimerHandler.h"


@interface TicTacToeViewController ()




@property int gameMatrixSize;
@property  NSMutableArray *buttons;

@property BOOL userTurn;
@property (weak, nonatomic) IBOutlet UILabel *whosTurnLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property int computerPlayCount;

@property MatrixIterator *matrixIterator;
@property TimerHandler *timerHandler;

@property NSMutableArray *matrixOfFiveZeroOne;

@end

@implementation TicTacToeViewController

- (void)setUpViews {
    
    int margin = 12;
    int topOffset = 40;
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    int screenHeight = size.height - 2 * margin;
    int screenWidth = size.width - 2 * margin;
    int extent = MIN(screenHeight, screenWidth);
    
    int x = margin;
    int y = margin + topOffset;
    
    int border = 4;
    
    int buttonWidth = extent / self.gameMatrixSize - border;
    
    NSMutableArray *stackViews = [NSMutableArray new];
    
    for (int i = 0; i < self.gameMatrixSize; i++) {
        
        NSMutableArray *buttons = [NSMutableArray new];
    
        for (int j = 0; j < self.gameMatrixSize; j++) {
            UIButton *button = [self setUpButtonsWithSize:buttonWidth];
            [buttons addObject:button];
            [self.buttons addObject:button];
            NSLog(@"%i",self.buttons.count);
        }
        
        UIStackView *horizontalStackView = [[UIStackView alloc] initWithArrangedSubviews:buttons];
        horizontalStackView.axis = UILayoutConstraintAxisHorizontal;
        horizontalStackView.distribution = UIStackViewDistributionFillEqually;
        [stackViews addObject:horizontalStackView];
    }
    
    UIStackView *superStackView = [[UIStackView alloc] initWithArrangedSubviews:stackViews];
    superStackView.axis = UILayoutConstraintAxisVertical;
    superStackView.distribution = UIStackViewDistributionFillEqually;

    superStackView.frame = CGRectMake(x, y, extent, extent);
    [self.view addSubview:superStackView];
}

- (UIButton *) setUpButtonsWithSize:(int)width {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, width, width);
    [button setBackgroundColor:[UIColor orangeColor]];
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 1;
    
    [button addTarget:self action:@selector(squareButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValuesToStart];
    
    
    
}

- (void)setupValuesToStart {
    for (UIButton *button in self.buttons) {
        [button setTitle:@"" forState:UIControlStateNormal];
        button.enabled = YES;
    }
    self.gameMatrixSize = 5;
    self.buttons = [NSMutableArray new];
    self.matrixIterator = [MatrixIterator new];
    [self setUpViews];
    
    
    self.matrixOfFiveZeroOne = [self.matrixIterator createMatrixWithRowsAndColumns:self.gameMatrixSize];
    self.timerHandler = [TimerHandler new];
    
    self.decrementSize = 0.1;
    self.timeBetweenTurns = 3.0;
    
    self.timerLabel.text = @"3.0";
    self.whosTurnLabel.text = @"You";
    self.computerPlayCount = 0;
    self.userTurn = YES;
    
   
}

- (IBAction)squareButton:(UIButton *)sender {
    
    switch (self.userTurn) {
        case 1:
            [sender setTitle:@"X" forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
            self.whosTurnLabel.text = @"Computer";
            
            break;
        case 0:
            [sender setTitle:@"O" forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
            self.whosTurnLabel.text = @"You";
            break;
    }
    
    [self updateOneMatrixElementOfFiveZeroOne:sender];
    
    sender.enabled = NO;
    sender.alpha = 1;
    [self checkForWinner];
    self.userTurn = !self.userTurn;
    self.timerLabel.text = @"3.0";
    
    [self.timerHandler buttonPushed];

    if (self.userTurn == 0) {
        [self computerPlay];
    }
}


- (void) computerPlay {
    if (self.computerPlayCount < (self.gameMatrixSize * self.gameMatrixSize) / 2) {
        
        int randomNumber = arc4random_uniform(self.buttons.count - 1);
        UIButton *button = [self.buttons objectAtIndex:randomNumber];
        
        int first = randomNumber / self.gameMatrixSize;
        int second = randomNumber % self.gameMatrixSize;
        
        
        if ([self.matrixOfFiveZeroOne[first][second] intValue] == 5) {
            [self squareButton:button];
            self.computerPlayCount++;
        } else {
            [self computerPlay];
        }
    }
}

-(void) updateOneMatrixElementOfFiveZeroOne:(UIButton *)button {
    int index = [self.buttons indexOfObject:button];
        int first = index / self.gameMatrixSize;
        int second = index % self.gameMatrixSize;
        self.matrixOfFiveZeroOne[first][second] = [self nsNumberFromButton:self.buttons[index]];
}

//START Get Current Matrix
- (void) updateMatrixOfFiveZeroOne {
    for (int i = 0; i < self.buttons.count; i++) {
        int first = i / self.gameMatrixSize;
        int second = i % self.gameMatrixSize;
        self.matrixOfFiveZeroOne[first][second] = [self nsNumberFromButton:self.buttons[i]];
    }
}
- (NSNumber *) nsNumberFromButton:(UIButton *)button {
    NSNumber *number = nil;
    if ([button.currentTitle isEqualToString:@"X"]) {
        number = [NSNumber numberWithInt:1];
    } else if ([button.currentTitle isEqualToString:@"O"]){
        number = [NSNumber numberWithInt:0];
    } else {
        number = [NSNumber numberWithInt:5];
    }
    return number;
}
//END Get Current Matrix

- (void) checkForWinner {
    BOOL didTheyWin = [self.matrixIterator checkMatches];
    
    if (didTheyWin) {
        [self displayVictoryMessage:@"You win!" title:@"Congratulations!"];
    }
}

- (void) displayVictoryMessage:(NSString *)message title:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"New game"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self setupValuesToStart];
                                                      }];
    [alertController addAction:actionOne];
    
    [self presentViewController:alertController animated:YES completion:^{
        //
    }];
}

- (IBAction)getHelp:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NLWebView" bundle:[NSBundle bundleWithIdentifier:@"io.lanza.NLWebView"]];
    NLWebViewVC *wvvc = [storyboard instantiateViewControllerWithIdentifier:@"vc"];
    
    [self presentViewController:wvvc animated:YES completion:^{
        [wvvc loadURL:@"https://en.wikipedia.org/wiki/Tic-tac-toe"];
    }];
}










@end
