//
//  Account.h
//  iALaCard
//
//  Created by Rodolfo Torres on 3/26/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"

@interface Account : NSObject
@property (strong, nonatomic) NSString *owner;
@property (strong, nonatomic) NSString *cardNumber;
@property (strong, nonatomic) NSString *balance;
@property (strong, nonatomic) NSString *balanceCurrent;
@property (strong, nonatomic) NSString *expirationDate;
@property (strong, nonatomic) NSString *cvv2;
@property (strong, nonatomic) NSDate *refreshDate;
@property (strong, nonatomic) NSMutableArray *transactions;

- (Account *) initWithParser:(TFHpple *) parser;
@end
