//
//  LogInViewController.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/22/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIView *credentialsView;
@property (strong, nonatomic) IBOutlet UITextField *txtCardNumber;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation LogInViewController

#define ANIMATION 2

- (IBAction)logIn
{
    if([self validInputs])
    {
        [SVProgressHUD showWithStatus: WAIT_LOG_IN_MSG maskType:SVProgressHUDMaskTypeGradient];
        
        [self.txtCardNumber resignFirstResponder];
        
        NSString *txtCardNumber = self.txtCardNumber.text;
        NSString *txtPassword = self.txtPassword.text;
        dispatch_async([aLaCardManager sharedQueue], ^{
            NSError *error;
            BOOL logIn = [[aLaCardManager sharedALaCardManager] logIn:txtCardNumber andPassword:txtPassword error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                if(logIn){
                    [SVProgressHUD showSuccessWithStatus:LOG_IN_OK];
                    [[NSUserDefaults standardUserDefaults] setObject:self.txtCardNumber.text forKey:CARD_NUMBER_KEY];
                    
                    [SFHFKeychainUtils storeUsername:self.txtCardNumber.text
                                         andPassword:self.txtPassword.text
                                      forServiceName:KEYCHAIN_SERVICE
                                      updateExisting:YES
                                               error:nil];
                    
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:ACCOUNT_REFRESH object:self userInfo:nil];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    if(error) //first time log in error
                    {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FIRST_LOG_IN_TITLE message:FIRST_LOG_IN_MSG delegate:self cancelButtonTitle:OK_BUTTON otherButtonTitles:nil]
                        ;
                        [alert show];
                    }
                    
                    [SVProgressHUD showErrorWithStatus:LOG_IN_NOTOK];
                }
            });
        });
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOG_IN_ERROR_TITLE message:LOG_IN_ERROR_MSG delegate:self cancelButtonTitle:OK_BUTTON otherButtonTitles:nil]
    ;    
        [alert show];
    }
}


- (BOOL) validInputs
{
    
    NSString *cardNumber = [self.txtCardNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *password = [self.txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return cardNumber.length > 0 && password.length > 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.credentialsView.alpha = 0;
    
    [self.txtCardNumber becomeFirstResponder];
    
    //debug mine
//    self.txtCardNumber.text = @"4246610400911733";
//    self.txtPassword.text = @"638638";
    
//    self.txtCardNumber.text = @"4246610401479235";
//    self.txtPassword.text = @"513513";
    
//        self.txtCardNumber.text = @"4246610402265609";
//        self.txtPassword.text = @"987654";
//    
    
//    
    self.txtPassword.secureTextEntry = YES;
    self.txtPassword.keyboardType = UIKeyboardTypeNumberPad;
    self.txtCardNumber.keyboardType = UIKeyboardTypeNumberPad;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [UIView animateWithDuration:ANIMATION animations:^{self.credentialsView.alpha = 1.0;}];
}

-(void) viewDidDisappear:(BOOL)animated
{
    self.credentialsView.alpha = 0;
}



@end
