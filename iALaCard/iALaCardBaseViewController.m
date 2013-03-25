//
//  iALaCardBaseViewController.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/22/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//
//  BaseViewController for sliding action configurations

#import "iALaCardBaseViewController.h"
@interface iALaCardBaseViewController ()

@end

@implementation iALaCardBaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    // You just need to set the opacity, radius, and color.
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[OptionsViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Options"];
    }
    
    //must be set to nil
    self.slidingViewController.underRightViewController = nil;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (IBAction)ShowOptions:(UIBarButtonItem *)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
