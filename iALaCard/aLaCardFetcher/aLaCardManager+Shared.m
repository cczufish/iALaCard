//
//  aLaCardManager+Shared.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/30/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "aLaCardManager+Shared.h"

#import "OldConnection.h"
#import "EuroCardConnection.h"

@implementation aLaCardManager (Shared)
+ (aLaCardManager *) sharedALaCardManager
{
    static aLaCardManager *shared;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        shared = [[aLaCardManager alloc]init];
    });
    
    return shared;
}

@end
