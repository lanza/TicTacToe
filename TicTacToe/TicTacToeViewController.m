#import "TicTacToeViewController.h"
#import "MatrixIterator.h"
#import <NLWebView/NLWebView.h>
#import "TimerHandler.h"
#import "Tile.h"
#import "Matrix.h"



@interface TicTacToeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *whosTurnLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property TimerHandler *timerHandler;
@property MatrixIterator *matrixIterator;

@property int dimension;
@property Matrix *matrix;

@property SquareOwnership whosTurn;
@property int computerPlayCount;

@end




@implementation TicTacToeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
    [self newGameSetup];
    
    for (Tile *tile in self.matrix.buttonsArray) {
        NSLog(@"index %d, row %d, column %d ", tile.arrayIndex, tile.firstIndex, tile.secondIndex);
    }
}

- (void)initialSetup {
    self.dimension = 3;
    self.matrix = [[Matrix alloc] initWithDimension:self.dimension];
    self.matrixIterator = [[MatrixIterator alloc]initWithMatrix: self.matrix];
    [self setUpViews];
    
    self.decrementSize = 0.1;
    self.timeBetweenTurns = 3.0;
    self.timerHandler = [TimerHandler new];
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
    
    [self.matrix buttonSelected:sender byPlayer:self.whosTurn];
    
    switch (self.whosTurn) {
        case User:
            [sender setTitle:@"X" forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
            self.whosTurnLabel.text = @"Computer";
            self.whosTurn = Computer;
            break;
        case Computer:
            [sender setTitle:@"O" forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
            self.whosTurnLabel.text = @"You";
            self.whosTurn = User;
            break;
        case Blank:
            assert(1);
            break;
    }
    
    sender.enabled = NO;
    sender.alpha = 1;
    
    if ([self.matrixIterator checkMatches]) {
        [self displayMessage:@"You win!" title:@"Congratulations!"];
    }
    
     self.timerLabel.text = @"3.0";
    
    [self.timerHandler buttonPushed];

    if (self.whosTurn == Computer) {
        [self computerPlay];
    }
}


- (void) computerPlay {
    if (self.computerPlayCount < (self.dimension * self.dimension) / 2) {
        
        int randomNumber = arc4random_uniform((self.dimension * self.dimension) - 1);
        Tile *button = [self.matrix tileAt:randomNumber];
        
        int first = randomNumber / self.dimension;
        int second = randomNumber % self.dimension;
                
        if ([self.matrix[first][second] intValue] == 0) {
            [self squareButton:button];
            self.computerPlayCount++;
        } else {
            [self computerPlay];
        }
    }
}


- (void) displayMessage:(NSString *)message title:(NSString *)title {
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
    [((NLWebViewVC *)segue.destinationViewController) loadURL:@"https://en.wikipedia.org/wiki/Tic-tac-toe"];
}

@end



