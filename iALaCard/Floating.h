//
//  Floating.h
//  iALaCard
//
//  Created by Rodolfo Torres on 3/27/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Floating : NSObject

@end
@interface NSObject(FloatingExtension)
/** Convience method for getting access to the ECSlidingViewController instance */
- (void)floating;
@end
