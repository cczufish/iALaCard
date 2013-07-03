//
//  iALaCardConnection+Shared.m
//  iALaCard
//
//  Created by Rodolfo Torres on 7/3/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "iALaCardConnection+Shared.h"
#import "EuroCardConnection.h"
#import "OldConnection.h"

@implementation iALaCardConnection (Shared)

static dispatch_once_t predC;
static int type = 0;

+ (iALaCardConnection *) sharedALaCardConnectionManager
{
    static iALaCardConnection *sharedC;
    
    
    dispatch_once(&predC, ^{
        sharedC = type == 0 ? [[OldConnection alloc]init] : [[EuroCardConnection alloc]init];
    });
    
    return sharedC;
}

+ (void) resetToEuroCard
{
    predC = 0;
    type = 1;
}

+ (void) resetToOld
{
    predC = 0;
    type = 0;
}

@end
