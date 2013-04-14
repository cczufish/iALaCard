//
//  BorderedTableView.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/31/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "BorderedTableView.h"
@implementation BorderedTableView

#define BACKGROUND_IMAGE @"tabela_movimentos.png"

- (void)drawRect:(CGRect)rect
{    
    UIImage *image = [UIImage imageNamed: BACKGROUND_IMAGE];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
