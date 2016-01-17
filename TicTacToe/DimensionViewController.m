#import "DimensionViewController.h"
#import "TicTacToeViewController.h"

@interface DimensionViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

@implementation DimensionViewController

- (void)viewDidLoad {
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
    [self.view addGestureRecognizer:tgr];
}

- (void) resign {
    [self.textField resignFirstResponder];
}


-(IBAction)dismissBackToDimensionScreen:(UIStoryboardSegue *)segue {
    
    TicTacToeViewController *sourceVC = (TicTacToeViewController *)(segue.sourceViewController);
    self.textField.text = [NSString stringWithFormat:@"%d",sourceVC.dimension];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ((TicTacToeViewController *)(segue.destinationViewController)).dimension = [self.textField.text intValue];
}

@end
