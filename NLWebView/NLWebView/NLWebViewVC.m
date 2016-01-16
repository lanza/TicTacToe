#import "NLWebViewVC.h"

@interface NLWebViewVC () <UIWebViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIScrollView *superScrollView;

@end

@implementation NLWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    [self checkBackAndForward];
    self.webView.scrollView.delegate = self;
    
    self.superScrollView.scrollEnabled = NO;
    
}

- (void)loadURL:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)checkBackAndForward {
    if ([self.webView canGoBack]) {
        self.backButton.enabled = YES;
    } else {
        self.backButton.enabled = NO;
    }
    if ([self.webView canGoForward]) {
        self.forwardButton.enabled = YES;
    } else {
        self.forwardButton.enabled = NO;
    }
}

//- (void)insertCurrentURLtoTextField {
//    NSString *url = [self.webView ]
//}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    NSString *urlString = textField.text;
    
    if (![urlString containsString:@"http://"]) {
        NSLog(@"%@",urlString);
        urlString = [NSString stringWithFormat:@"http://%@",urlString];
        NSLog(@"%@",urlString);
    }
    NSLog(@"%@",urlString);
    
    [self loadURL:urlString];

    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicator startAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
    [self checkBackAndForward];
    
    self.textField.text = [self.webView.request.URL absoluteString];
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}




- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {
        
        CGPoint position = CGPointMake(0, MIN(37, scrollView.contentOffset.y));
        [self.superScrollView setContentOffset:position animated:NO];
    } else if (scrollView.contentOffset.y < 0) {
        CGPoint position = CGPointMake(0, MIN(0,37 - scrollView.contentOffset.y));
        [self.superScrollView setContentOffset:position animated:NO];
    }
}


- (IBAction)onBackButtonPressed:(id)sender {
    [self.webView goBack];
    [self checkBackAndForward];
}

- (IBAction)onForwardButtonPressed:(id)sender {
    [self.webView goForward];
    [self checkBackAndForward];

}

- (IBAction)onStopLoadingButtonPressed:(id)sender {
    [self.webView stopLoading];
}
- (IBAction)onReloadButtonPressed:(id)sender {
    [self.webView reload];
}
- (IBAction)comingSoon:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Coming soon!"
                                                                             message:@"New features!"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"Okay"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          //okay
                                                      }];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          //something
                                                      }];
                                
    [alertController addAction:actionOne];
    [alertController addAction:actionTwo];
    
    [self presentViewController:alertController animated:YES completion:^{
        //something
    }];
    
}

@end
