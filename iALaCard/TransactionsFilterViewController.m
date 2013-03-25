//
//  TransactionsFilterViewController.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/22/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "TransactionsFilterViewController.h"
#import "ECSlidingViewController.h"
@interface TransactionsFilterViewController ()
@end

@implementation TransactionsFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.slidingViewController setAnchorLeftPeekAmount:40.0f];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
}

@end
