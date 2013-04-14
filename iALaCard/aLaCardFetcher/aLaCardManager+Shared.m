//
//  aLaCardManager+Shared.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/30/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "aLaCardManager+Shared.h"

@implementation aLaCardManager (Shared)
+ (aLaCardManager *) sharedALaCardManager
{
    static aLaCardManager *shared = nil;
    
    if(!shared){
        shared = [[aLaCardManager alloc]init];
    }
    return shared;
}

@end
