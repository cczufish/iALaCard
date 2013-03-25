//
//  NavigationViewController.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/22/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "NavigationViewController.h"
#import "ECSlidingViewController.h"
#import "OptionsViewController.h"
#import "TransactionsFilterViewController.h"
@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[OptionsViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Options"];
    }
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[TransactionsFilterViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TransactionsFilter"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}


@end
