//
//  iALaCardViewController.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/22/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "iALaCardViewController.h"
#import "UIManagedDocument+Shared.h"

@interface iALaCardViewController ()

@end

@implementation iALaCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"Account"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
