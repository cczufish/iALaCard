//
//  FloatingView.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/23/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "FloatingView.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS 15.0f
#define BORDER_WIDTH 0.5f
#define SHADOW_OPACITY 0.8
#define SHADOW_RADIUS 2.0
#define SHADOW_OFFSET 1.0
#define COLOR [UIColor whiteColor].CGColor

@implementation FloatingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void) didMoveToWindow
{
    [super didMoveToWindow];
    if(self.layer.cornerRadius != CORNER_RADIUS)
    {
        [self.layer setCornerRadius:CORNER_RADIUS];
        [self.layer setBorderColor:COLOR];
        [self.layer setBorderWidth:BORDER_WIDTH];
        [self.layer setShadowColor:COLOR];
        [self.layer setShadowOpacity:SHADOW_OPACITY];
        [self.layer setShadowRadius:SHADOW_RADIUS];
        [self.layer setShadowOffset:CGSizeMake(SHADOW_OFFSET, SHADOW_OFFSET)];
    }
}

@end
