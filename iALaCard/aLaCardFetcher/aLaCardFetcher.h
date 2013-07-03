//
//  aLaCardFetcher.h
//  aLaCard
//
//  Created by Rodolfo Torres on 3/17/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"
#import "Constants.h"
#import "SFHFKeychainUtils.h"
#import "iALaCardConnection+Shared.h"
#import "OldConnection.h"

@interface aLaCardFetcher : NSObject
+ (TFHpple *) account;
+ (TFHpple *) transactions;
+ (TFHpple *) logIn:(NSString *) cardNumber andPassword:(NSString *) password;
+ (void) logOut;
+ (NSString *) action:(TFHpple* )parser;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *key;
@end
