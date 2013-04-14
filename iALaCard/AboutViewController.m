//
//  AboutViewController.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/22/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "AboutViewController.h"
@interface AboutViewController ()
@property (strong, nonatomic) UIActionSheet *callActionSheet;
@property (strong, nonatomic) UIActionSheet *sendEmailActionSheet;
@end

@implementation AboutViewController

#define COLOR 0.2941

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    //HACK: using the draw rect the view from UIViewBlack view desappears when sliding
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:COLOR green:COLOR blue:COLOR alpha:1.0] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (IBAction)call:(id)sender
{
    [self.callActionSheet showInView:self.view];
}
- (IBAction)sendEmail:(id)sender
{
    [self.sendEmailActionSheet showInView:self.view];
}

-(UIActionSheet *) callActionSheet
{
    if(!_callActionSheet)
    {
        _callActionSheet = [[UIActionSheet alloc] initWithTitle: CALL_MSG delegate:self cancelButtonTitle: CANCEL_BUTTON destructiveButtonTitle: CALL_BUTTON otherButtonTitles:nil, nil];
    }
    
    return _callActionSheet;
}

-(UIActionSheet *) sendEmailActionSheet
{
    if(!_sendEmailActionSheet)
    {
        _sendEmailActionSheet = [[UIActionSheet alloc] initWithTitle: EMAIL_MSG delegate:self cancelButtonTitle: CANCEL_BUTTON destructiveButtonTitle: EMAIL_BUTTON otherButtonTitles:nil, nil];
    }
    
    return _sendEmailActionSheet;
}

-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == self.callActionSheet.destructiveButtonIndex)
    {
        if (actionSheet == self.callActionSheet) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: CALL_ACTION]];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: EMAIL_ACTION]];
        }
    }
}

@end
