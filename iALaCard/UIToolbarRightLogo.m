//
//  UIToolbarRightLogo.m
//  iALaCard
//
//  Created by Rodolfo Torres on 4/9/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "UIToolbarRightLogo.h"

@implementation UIToolbarRightLogo

#define BACKGROUND_IMAGE @"barra_verde_v1.png"
#define BACKGROUND_IMAGE_NOLOGO @"barra_verde.png"


- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed: [Constants isPad] ? BACKGROUND_IMAGE_NOLOGO : BACKGROUND_IMAGE];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
