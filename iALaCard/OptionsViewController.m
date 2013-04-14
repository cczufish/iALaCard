//
//  OptionsViewController.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/22/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "OptionsViewController.h"

@interface OptionsViewController () <UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnAccount;
@property (strong, nonatomic) IBOutlet UIButton *btnHistory;
@property (strong, nonatomic) IBOutlet UIButton *btnLogOut;
@property (strong, nonatomic) IBOutlet UIButton *btnAbout;
@property (strong, nonatomic) IBOutlet UILabel *lblOwner;

@property (strong, nonatomic) UIButton *selectedButton;

@property (strong, nonatomic) UIActionSheet *actionSheet;
@end

@implementation OptionsViewController

#define ANIMATION 0.2
#define SPACE 200.0f

//action sheet for logging out
-(UIActionSheet *) actionSheet
{
    if(!_actionSheet)
    {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:LOG_OUT_MSG delegate:self cancelButtonTitle: CANCEL_BUTTON destructiveButtonTitle: LEAVE_BUTTON otherButtonTitles:nil, nil];
    }
    
    return _actionSheet;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.slidingViewController setAnchorRightRevealAmount:SPACE];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    self.selectedButton = self.btnAccount;
    
    self.selectedButton.selected = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.btnAccount.alpha = self.btnHistory.alpha = self.btnLogOut.alpha = self.btnAbout.alpha = 0.0;
    self.lblOwner.text = [[NSUserDefaults standardUserDefaults] objectForKey:CARD_OWNER_KEY];
    [self pushButtons];
}

#pragma mark - animated buttons

-(void) pushButtons
{
    [UIView animateWithDuration:ANIMATION animations:^{
        self.btnAccount.alpha = 1.0;
    } completion:^(BOOL finished) {
        if(finished){
            [UIView animateWithDuration:ANIMATION animations:^{
                self.btnHistory.alpha = 1.0;
            } completion:^(BOOL finished) {
                if(finished){
                    [UIView animateWithDuration:ANIMATION animations:^{
                        self.btnAbout.alpha = 1.0;
                    } completion:^(BOOL finished) {
                        if(finished){
                            [UIView animateWithDuration:ANIMATION animations:^{
                                self.btnLogOut.alpha = 1.0;
                            }];
                        }
                    }];
                }
            }];
        }
    }];
}

#pragma mark - actions

-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == self.actionSheet.destructiveButtonIndex)
    {
        dispatch_async(dispatch_queue_create("fetcher", NULL), ^{[aLaCardFetcher logOut];});
        
        //delete user defaults
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:CARD_NUMBER_KEY];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:CARD_OWNER_KEY];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LOG_OFF object:self userInfo:nil];
        
        [self pushAccount:self.btnAccount];
    }
}

- (void) navigateTo:(NSString *) controllName
{
    UIViewController *topViewController = [self.iALaCardViewController.controls objectForKey:controllName];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = topViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (void) toggleButton:(UIButton *) button
{
    if(button != self.selectedButton)
    {
        
        self.selectedButton.selected = NO;
        
        self.selectedButton = button;
        
        self.selectedButton.selected = YES;
    }
}

- (IBAction)pushAccount:(UIButton *)sender
{
    [self toggleButton:sender];
    [self navigateTo:ACCOUNT_CONTROLLER];
}

- (IBAction)pushHistory:(UIButton *)sender
{
    [self toggleButton:sender];
    [self navigateTo:HISTORY_CONTROLLER];
}
- (IBAction)pushAbout:(UIButton *)sender
{
    [self toggleButton:sender];
    [self navigateTo:ABOUT_CONTROLLER];
}

- (IBAction)pushLogOut:(id)sender
{
    [self.actionSheet showInView:self.view];
}


@end
