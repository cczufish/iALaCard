//
//  iALaCardViewController.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/22/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "iALaCardViewController.h"

@interface iALaCardViewController ()

@end

@implementation iALaCardViewController

//getter for the controls
-(NSMutableDictionary * ) controls
{
    if(!_controls)
    {
        _controls = [[NSMutableDictionary alloc] init];
    }
    
    return _controls;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startup];
}

//startup operations
//initializes all controlls for the application and stores them in the dict
- (IBAction)startup
{
    [aLaCardManager sharedALaCardManager];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:ACCOUNT_CONTROLLER];
    
    [self.controls setObject:self.topViewController forKey:ACCOUNT_CONTROLLER];
    [self.controls setObject:[storyboard instantiateViewControllerWithIdentifier:ABOUT_CONTROLLER] forKey:ABOUT_CONTROLLER];
    [self.controls setObject:[storyboard instantiateViewControllerWithIdentifier:HISTORY_CONTROLLER] forKey:HISTORY_CONTROLLER];
}

@end

@implementation UIViewController(iALaCardViewExtension)
//returns the parent controller
- (iALaCardViewController *)iALaCardViewController
{
    UIViewController *viewController = self.parentViewController;
    while (!(viewController == nil || [viewController isKindOfClass:[iALaCardViewController class]])) {
        viewController = viewController.parentViewController;
    }
    
    return (iALaCardViewController *)viewController;
}
@end
