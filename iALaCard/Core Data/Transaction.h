//
//  Transaction.h
//  iALaCard
//
//  Created by Rodolfo Torres on 3/24/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account;

@interface Transaction : NSManagedObject

@property (nonatomic, retain) NSString * transactionId;
@property (nonatomic, retain) NSString * transactionDescription;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * debit;
@property (nonatomic, retain) NSString * credit;
@property (nonatomic, retain) NSString * transactionType;
@property (nonatomic, retain) Account *account;

@end
