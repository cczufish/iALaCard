//
//  Transaction+Create.h
//  iALaCard
//
//  Created by Rodolfo Torres on 3/24/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "Transaction.h"
#import "TFHpple.h"
#import "Constants.h"
#define XPATH_QUERY_1 @"//tr[@class='tablerowalt1']"
#define XPATH_QUERY_2 @"//tr[@class='tablerowalt2']"
#define XPATH_QUERY_3 @"//*[@id='j_idt94:j_idt95:transactionsTable:tb']/tr"
#define TRANSACTION_ID @"transactionId"
#define DATE_FORMAT @"dd/MM/yy"

@interface Transaction (Create)
+ (NSMutableArray *)transactionsWithParser:(TFHpple *)parser;
+ (Transaction *) transactionWithArray: (NSArray *) array;
+ (NSArray *) getNodesFromParser:(TFHpple *) parser;
@end
