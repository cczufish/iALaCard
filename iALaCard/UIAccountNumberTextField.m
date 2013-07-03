//
//  UIAccountNumberTextField.m
//  iALaCard
//
//  Created by Rodolfo Torres on 5/6/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "UIAccountNumberTextField.h"

@implementation UIAccountNumberTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
    }
    return self;
}



@end
