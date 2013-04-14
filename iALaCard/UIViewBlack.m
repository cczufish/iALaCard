//
//  UIViewBlack.m
//  iALaCard
//
//  Created by Rodolfo Torres on 4/9/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "UIViewBlack.h"

@implementation UIViewBlack


- (void)drawRect:(CGRect)rect
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.layer insertSublayer:gradient atIndex:0];
}

@end
