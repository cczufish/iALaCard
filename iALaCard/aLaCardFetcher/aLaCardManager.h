//
//  aLaCardManager.h
//  iALaCard
//
//  Created by Rodolfo Torres on 3/30/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "aLaCardFetcher.h"
#import "Transaction+Create.h"
#import "Transactions.h"
#import "SVProgressHUD.h"
#import "Constants.h"
#import "TWStatus.h"

@interface aLaCardManager : NSObject
@property (nonatomic, strong) Account *account;
@property (nonatomic, strong) Transactions *transactions;
- (BOOL) logIn:(NSString *) cardNumber andPassword:(NSString *) password error:(NSError **) error;
- (BOOL) refreshLogInError: (NSError **) error;
+ (dispatch_queue_t)sharedQueue;
- (void) logOut;
@end
