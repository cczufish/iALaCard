//
//  iALaCardConnection+Shared.h
//  iALaCard
//
//  Created by Rodolfo Torres on 7/3/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "iALaCardConnection.h"

@interface iALaCardConnection (Shared)

+ (iALaCardConnection *) sharedALaCardConnectionManager;

+ (void) resetToEuroCard;
+ (void) resetToOld;
@end
