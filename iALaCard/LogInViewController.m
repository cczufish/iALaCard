//
//  LogInViewController.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/22/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "LogInViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SFHFKeychainUtils.h"
#import "aLaCardFetcher.h"
#import "TFHpple.h"

@interface LogInViewController ()
@property (strong, nonatomic) IBOutlet UIView *welcomeView;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIView *credentialsView;
@property (strong, nonatomic) IBOutlet UITextField *txtCardNumber;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation LogInViewController

- (IBAction)logIn
{
    [self.spinner startAnimating];
    
    [self.txtCardNumber resignFirstResponder];
    
    dispatch_queue_t loginQ = dispatch_queue_create("login", NULL);
    dispatch_async(loginQ, ^{
        BOOL logIn = [aLaCardFetcher logIn:self.txtCardNumber.text andPassword:self.txtPassword.text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            if(logIn){
                [[NSUserDefaults standardUserDefaults] setObject:self.txtCardNumber.text forKey:CARD_NUMBER_KEY];
                
                [SFHFKeychainUtils storeUsername:self.txtCardNumber.text
                                     andPassword:self.txtPassword.text
                                  forServiceName:KEYCHAIN_SERVICE
                                  updateExisting:YES
                                           error:nil];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.credentialsView.alpha = 0;
    
    [self.txtCardNumber becomeFirstResponder];
    
    self.txtCardNumber.text = @"4246610400911733";
    self.txtPassword.text = @"638638";
    
    self.txtPassword.secureTextEntry = YES;
    
    self.txtCardNumber.keyboardType = UIKeyboardTypeNumberPad;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [UIView animateWithDuration:2 animations:^{self.credentialsView.alpha = 1.0;}];
}

-(void) viewDidDisappear:(BOOL)animated
{
    self.credentialsView.alpha = 0;
    [self.welcomeView setCenter:self.view.center];
}



@end
