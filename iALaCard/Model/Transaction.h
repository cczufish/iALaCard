//
//  Transaction.h
//  iALaCard
//
//  Created by Rodolfo Torres on 3/24/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject

@property (nonatomic, strong) NSString * transactionId;
@property (nonatomic, strong) NSString * transactionDescription;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSString * debit;
@property (nonatomic, strong) NSString * credit;
@property (nonatomic, strong) NSString * transactionType;

@end
