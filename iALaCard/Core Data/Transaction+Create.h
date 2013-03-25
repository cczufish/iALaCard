//
//  Transaction+Create.h
//  iALaCard
//
//  Created by Rodolfo Torres on 3/24/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "Transaction.h"
#import "TFHpple.h"

@interface Transaction (Create)
+ (NSSet *)transactionsWithParser:(TFHpple *)parser
           inManagedObjectContext:(NSManagedObjectContext *)context;
@end
