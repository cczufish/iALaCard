//
//  iALaCardViewController.h
//  iALaCard
//
//  Created by Rodolfo Torres on 3/22/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "aLaCardManager+Shared.h"

@interface iALaCardViewController : ECSlidingViewController
@property (strong, nonatomic) NSMutableDictionary *controls;
@end
@interface UIViewController(iALaCardViewExtension)
//extension for the base view controller
- (iALaCardViewController *)iALaCardViewController;
@end
