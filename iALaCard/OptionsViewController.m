//
//  OptionsViewController.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/22/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "OptionsViewController.h"
#import "ECSlidingViewController.h"
#import "SFHFKeychainUtils.h"
#import "aLaCardFetcher.h"

@interface OptionsViewController () <UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnAccount;
@property (strong, nonatomic) IBOutlet UIButton *btnRecent;
@property (strong, nonatomic) IBOutlet UIButton *btnHistory;
@property (strong, nonatomic) IBOutlet UIButton *btnLogOut;
@property (strong, nonatomic) IBOutlet UIButton *btnAbout;

@property (strong, nonatomic) NSMutableDictionary *controllers;

@property (strong, nonatomic) UIActionSheet *actionSheet;
@end

@implementation OptionsViewController


- (NSMutableDictionary *) controllers
{
    if(!_controllers)
    {
        _controllers = [[NSMutableDictionary alloc] init];
    }

    return _controllers;
}

-(UIActionSheet *) actionSheet
{
    if(!_actionSheet)
    {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"Deseja efectuar o log out?" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:@"Log out" otherButtonTitles:nil, nil];
    }
    
    return _actionSheet;
}

-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == self.actionSheet.destructiveButtonIndex)
    {
        dispatch_async(dispatch_queue_create("logoff", NULL), ^{[aLaCardFetcher logOut];});
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:CARD_NUMBER_KEY];
        [self navigateTo:@"Account"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.slidingViewController setAnchorRightRevealAmount:200.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
}

- (void) navigateTo:(NSString *) controllName
{
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:controllName];
    
    NSString *tag = [NSString stringWithFormat:@"%d", newTopViewController.view.tag];
    
    UIViewController *savedViewController = [self.controllers objectForKey:tag];
    
    if(savedViewController) //stored controller
    {
        newTopViewController = savedViewController;
        
    }else if(self.slidingViewController.topViewController.view.tag == newTopViewController.view.tag){ //same controller
        newTopViewController = self.slidingViewController.topViewController;
    }
    
    [self.controllers setObject:self.slidingViewController.topViewController forKey:[NSString stringWithFormat:@"%d", self.slidingViewController.topViewController.view.tag]];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
    
    if(!newTopViewController)
    {
        [self.controllers setObject:self.slidingViewController.topViewController forKey:[NSString stringWithFormat: @"%d", self.slidingViewController.topViewController.view.tag]];
        newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:controllName];
    }
    

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.btnAccount.alpha = self.btnRecent.alpha = self.btnHistory.alpha = self.btnLogOut.alpha = self.btnAbout.alpha = 0.0;
    
    [self pushButtons];
}

-(void) pushButtons
{
    [UIView animateWithDuration:0.2 animations:^{
        self.btnAccount.alpha = 1.0;
    } completion:^(BOOL finished) {
        if(finished){
            [UIView animateWithDuration:0.2 animations:^{
                self.btnRecent.alpha = 1.0;
            } completion:^(BOOL finished) {
                if(finished){
                    [UIView animateWithDuration:0.2 animations:^{
                        self.btnHistory.alpha = 1.0;
                    } completion:^(BOOL finished) {
                        if(finished){
                            [UIView animateWithDuration:0.2 animations:^{
                                self.btnLogOut.alpha = 1.0;
                            } completion:^(BOOL finished) {
                                if(finished){
                                    [UIView animateWithDuration:0.2 animations:^{
                                        self.btnAbout.alpha = 1.0;
                                    }];
                                }
                            }];
                        }
                    }];
                }
            }];
        }
    }];
    
}

- (IBAction)pushAccount:(UIButton *)sender
{
    [self navigateTo:@"Account"];
}
- (IBAction)historyPush:(UIButton *)sender
{
    [self navigateTo:@"History"];
}

- (IBAction)aboutPush
{
    [self navigateTo:@"About"];
}

- (IBAction)logOut
{
    [self.actionSheet showInView:self.view];
}
@end
