#import "TicTacToeViewController.h"
#import "MatrixIterator.h"
#import <NLWebView/NLWebView.h>
#import "TimerHandler.h"
#import "Tile.h"
#import "Matrix.h"
#import "ComputerAI.h"



@interface TicTacToeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *whosTurnLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) UIButton *draggableButton;

@property TimerHandler *timerHandler;
@property MatrixIterator *matrixIterator;


@property Matrix *matrix;

@property SquareOwnership whosTurn;
@property int computerPlayCount;

@property ComputerAI *computerAI;

@property UIStackView *superStackView;

@end


@implementation TicTacToeViewController


- (double)getCurrentTimeRemaining {
    return [self.timerLabel.text doubleValue];
}


- (void)newTimerLabelText:(NSString *)text {
    self.timerLabel.text = text;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.draggableButton.enabled = NO;
    
    [self initialSetup];
    [self newGameSetup];
    
    self.draggableButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self reframeDraggableButton];
    [self.view addSubview:self.draggableButton];
    [self.draggableButton setTitle:@"X" forState:UIControlStateNormal];
    
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragButton:)];
    [self.draggableButton addGestureRecognizer:pgr];
}

-(void)reframeDraggableButton {
    
    CGFloat mainViewWidth = self.view.frame.size.width;
    CGFloat mainViewHeight = self.view.frame.size.height;
    
    CGRect newFrame = CGRectMake(mainViewWidth * 0.8, mainViewHeight * 0.8, mainViewWidth * 0.1, mainViewHeight * 0.1);
    [self.draggableButton setFrame:newFrame];
}

- (void) dragButton:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:self.view];
    CGRect currentLocation = self.draggableButton.frame;
    CGRect newLocation = CGRectMake(currentLocation.origin.x + point.x, currentLocation.origin.y + point.y, currentLocation.size.width, currentLocation.size.height);
    [self.draggableButton setFrame:newLocation];
    [sender setTranslation:CGPointZero inView:self.view];
    
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        for (Tile *tile in self.matrix.buttonsArray) {
            CGRect converted = [tile.superview convertRect:tile.frame toView:self.view];
            if (CGRectIntersectsRect(converted, self.draggableButton.frame)) {
                if (tile.enabled != NO) {
                    [self squareButton:tile];
                }
            }
        }
        [self reframeDraggableButton];
    }
}


- (void)initialSetup {
    self.matrix = [[Matrix alloc] initWithDimension:self.dimension];
    self.matrixIterator = [[MatrixIterator alloc]initWithMatrix: self.matrix];
    [self setUpViews];
    [self.matrix setUpMatrix];
    
    
    self.decrementSize = 0.1;
    self.timeBetweenTurns = 3.0;
    self.timerHandler = [TimerHandler new];
    self.timerHandler.decrementSize = self.decrementSize;
    self.timerHandler.timeBetweenTurns = self.timeBetweenTurns;
    self.timerHandler.tttvc = self;
    
    self.computerAI = [ComputerAI new];
    self.computerAI.matrix = self.matrix;
    self.computerAI.dimension = self.dimension;
}

- (void)newGameSetup {
    [self blankOutButtons];
    [self.matrix blankOutMatrix];
    
    self.timerLabel.text = @"3.0";
    self.whosTurnLabel.text = @"You";
    self.computerPlayCount = 0;
    self.whosTurn = User;
}

- (void)blankOutButtons {
    for (Tile *button in self.matrix.buttonsArray) {
        [button setTitle:@"" forState:UIControlStateNormal];
        button.enabled = YES;
    }
}

- (void)setUpViews {
    
    int margin = 12;
    int topOffset = 40;
    int border = 4;
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    int screenHeight = size.height - 2 * margin;
    int screenWidth = size.width - 2 * margin;
    int extent = MIN(screenHeight, screenWidth);
    int buttonWidth = extent / self.dimension - border;
    
    int x = margin;
    int y = margin + topOffset;
    
    NSMutableArray *stackViews = [NSMutableArray new];
    
    for (int i = 0; i < self.dimension; i++) {
        NSMutableArray *buttons = [NSMutableArray new];
        
        for (int j = 0; j < self.dimension; j++) {
            Tile *button = [self setUpButtonsWithSize:buttonWidth];
            [self.matrix.buttonsArray addObject:button];
            [buttons addObject:button];
            button.arrayIndex = [self.matrix.buttonsArray indexOfObject:button];
            button.firstIndex = button.arrayIndex / self.dimension;
            button.secondIndex = button.arrayIndex % self.dimension;
            button.buttonOwner = 0;
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
    self.superStackView = superStackView;
}

- (Tile *) setUpButtonsWithSize:(int)width {
    Tile *button = [Tile buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, width, width);
    [button setBackgroundColor:[UIColor orangeColor]];
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 1;
    
    [button addTarget:self action:@selector(squareButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (IBAction)squareButton:(Tile *)sender {
    
    sender.buttonOwner = self.whosTurn;
    
    switch (self.whosTurn) {
        case User:
            [sender setTitle:@"X" forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
            self.whosTurnLabel.text = @"Computer";
            self.whosTurn = Computer;
            
            if ([self.matrixIterator checkMatches]) {
                [self displayMessage:@"You win!" title:@"Congratulations!"];
            } else {
                [self.timerHandler startNewTurnTimer];
            }
            
            break;
        case Computer:
            [sender setTitle:@"O" forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
            self.whosTurnLabel.text = @"You";
            self.whosTurn = User;
            
            if ([self.matrixIterator checkMatches]) {
                [self displayMessage:@"You lose!" title:@"The computer wins."];
            } else {
                [self.timerHandler startNewTurnTimer];
            }
            
            break;
        case Blank:
            assert(1);
            break;
    }
    
    sender.enabled = NO;
    sender.alpha = 1;
    
    
    
    self.timerLabel.text = @"3.0";
    
    
    
    if (self.whosTurn == Computer) {
        [self computerPlay];
    }
}


- (void) computerPlay {
    if (self.computerPlayCount < (self.dimension * self.dimension) / 2) {
        
        [self squareButton:[self.computerAI whereShouldComputerPlay]];
        self.computerPlayCount++;
        
        NSLog(@"%d",self.computerPlayCount);
        if (self.dimension % 2 == 0) {
            if (self.computerPlayCount == (self.dimension * self.dimension) / 2) {
                [self displayMessage:@"It's a draw!" title:@"Nobody wins"];
            }
        }
    } else {
        [self displayMessage:@"It's a draw!" title:@"Nobody wins"];
    }
    
    
    
}


- (void) displayMessage:(NSString *)message title:(NSString *)title {
    NSLog(@"displayMessage called");
    [self.timerHandler invalidateAllTimers];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"New game"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self newGameSetup];
                                                      }];
    [alertController addAction:actionOne];
    
    [self presentViewController:alertController animated:YES completion:^{
        //
    }];
}

@end

@implementation TicTacToeViewController (Segues)

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"web"]) {
        [((NLWebViewVC *)segue.destinationViewController) loadURL:@"https://en.wikipedia.org/wiki/Tic-tac-toe"];
    }
}


- (IBAction)dimensionsButtonPushed:(id)sender {
    
    
    
    
    
    [self initialSetup];
    [self newGameSetup];
}

@end



