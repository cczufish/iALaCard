//
//  Account+Create.h
//  iALaCard
//
//  Created by Rodolfo Torres on 3/24/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "Account.h"
#import "TFHpple.h"

@interface Account (Create)

+ (Account *)accountWithParser:(TFHpple *)parser
        inManagedObjectContext:(NSManagedObjectContext *)context;
@end
