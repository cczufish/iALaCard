//
//  Account.h
//  iALaCard
//
//  Created by Rodolfo Torres on 3/24/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Transaction;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * owner;
@property (nonatomic, retain) NSDate * refreshDate;
@property (nonatomic, retain) NSString * expirationDate;
@property (nonatomic, retain) NSString * cvv2;
@property (nonatomic, retain) NSString * cardNumber;
@property (nonatomic, retain) NSString * balance;
@property (nonatomic, retain) NSString * balanceCurrent;
@property (nonatomic, retain) NSSet *transaction;
@end

@interface Account (CoreDataGeneratedAccessors)

- (void)addTransactionObject:(Transaction *)value;
- (void)removeTransactionObject:(Transaction *)value;
- (void)addTransaction:(NSSet *)values;
- (void)removeTransaction:(NSSet *)values;

@end
