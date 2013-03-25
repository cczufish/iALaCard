//
//  aLaCardFetcher.h
//  aLaCard
//
//  Created by Rodolfo Torres on 3/17/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"
@interface aLaCardFetcher : NSObject
+ (TFHpple *) account;
+ (TFHpple *) transactions;
+ (BOOL) logIn:(NSString *) cardNumber andPassword:(NSString *) password;
+ (void) logOut;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *key;
@end
