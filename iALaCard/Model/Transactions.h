//
//  Transactions.h
//  iALaCard
//
//  Created by Rodolfo Torres on 4/7/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"
#import "Transaction.h"
#import "Transaction+Create.h"

@interface Transactions : NSObject
@property (strong, nonatomic) NSDate *lastRefreshDate;
@property (strong, nonatomic) NSDictionary *transactionsDictionary;
@property (assign, nonatomic) BOOL needsRefresh;

- (Transactions *) initWithParser:(TFHpple *) parser;
@end
