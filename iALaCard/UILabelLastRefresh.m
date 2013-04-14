//
//  UILabelLastRefresh.m
//  iALaCard
//
//  Created by Rodolfo Torres on 4/9/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "UILabelLastRefresh.h"

@implementation UILabelLastRefresh

#define BACKGROUND_IMAGE @"tabela_movimentos_v2.png"

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed: BACKGROUND_IMAGE];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
