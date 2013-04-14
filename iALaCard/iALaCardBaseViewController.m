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

#define SHADOW_OPACITY 0.75f
#define SHADOW_RADIUS 10.0f
#define OPTIONS_CONTROL @"Options"

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    // You just need to set the opacity, radius, and color.
    self.view.layer.shadowOpacity = SHADOW_OPACITY;
    self.view.layer.shadowRadius = SHADOW_RADIUS;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[OptionsViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:OPTIONS_CONTROL];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (IBAction)ShowOptions:(UIBarButtonItem *)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
