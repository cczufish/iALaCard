//
//  Account+Create.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/24/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "Account+Create.h"
#import "TFHpple.h"
#import "Transaction+Create.h"

#define OWNER_KEY @"owner"
#define OWNER_DESCRIPTION @"Nome no cartão"

#define BALANCE_KEY @"balance"
#define BALANCE_DESCRIPTION @"Saldo contabilístico"

#define BALANCE_CURRENT_KEY @"balanceCurrent"
#define BALANCE_CURRENT_DESCRIPTION @"Saldo disponível"

#define EXPIRATION_DATE_KEY @"expirationDate"
#define EXPIRATION_DATE_DESCRIPTION @"Data de validade do cartão"

#define CVV2_KEY @"cvv2"
#define CVV2_DESCRIPTION @"Código de segurança "

@implementation Account (Create)

+ (Account *)accountWithParser:(TFHpple *)parser
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Account *account = nil;
    if(parser)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        NSString *formLabelXpathQueryString = @"//td";
        NSArray *formLabelNodes = [parser searchWithXPathQuery:formLabelXpathQueryString];
        for (TFHppleElement *element in formLabelNodes) {
            //NSLog(@"conteudo %@",[[element firstChild] content]);
            if([[[element firstChild] content] isEqualToString:@"Nome no cartão"]){
                
                TFHppleElement *elementOwner = [formLabelNodes objectAtIndex:[formLabelNodes indexOfObject:element]+1];
                [dict setObject:[[[elementOwner firstChild] content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:OWNER_KEY];
                //NSLog(@"%@: %@", OWNER_DESCRIPTION, [[elementOwner firstChild] content]);
            }else if([[[element firstChild] content] isEqualToString:BALANCE_DESCRIPTION]){
                TFHppleElement *elementOwner = [formLabelNodes objectAtIndex:[formLabelNodes indexOfObject:element]+1];
                [dict setObject:[[[elementOwner firstChild] content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:BALANCE_KEY];
                //NSLog(@"%@: %@", BALANCE_DESCRIPTION, [[elementOwner firstChild] content]);
            }else if([[[element firstChild] content] isEqualToString:BALANCE_CURRENT_DESCRIPTION]){
                TFHppleElement *elementOwner = [formLabelNodes objectAtIndex:[formLabelNodes indexOfObject:element]+1];
                [dict setObject:[[[elementOwner firstChild] content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:BALANCE_CURRENT_KEY];
                //NSLog(@"%@: %@", BALANCE_CURRENT_DESCRIPTION, [[elementOwner firstChild] content]);
            }else if([[[element firstChild] content] isEqualToString:EXPIRATION_DATE_DESCRIPTION]){
                TFHppleElement *elementOwner = [formLabelNodes objectAtIndex:[formLabelNodes indexOfObject:element]+1];
                [dict setObject:[[[elementOwner firstChild] content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:EXPIRATION_DATE_KEY];
                //NSLog(@"%@: %@", EXPIRATION_DATE_DESCRIPTION, [[elementOwner firstChild] content]);
            }else if([[[element firstChild] content] isEqualToString:CVV2_DESCRIPTION]){
                TFHppleElement *elementOwner = [formLabelNodes objectAtIndex:[formLabelNodes indexOfObject:element]+1];
                [dict setObject:[[[elementOwner firstChild] content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:CVV2_KEY];
                //NSLog(@"%@: %@", EXPIRATION_DATE_DESCRIPTION, [[elementOwner firstChild] content]);
                
                break; //no more data
            }
        }
        
        account = [Account accountWithDictionary:dict inManagedObjectContext:context];
        
//        [Transaction transactionsWithParser:parser inManagedObjectContext:context];
    }
    
    return account;
}



+ (Account *)accountWithDictionary:(NSDictionary *)dict
            inManagedObjectContext:(NSManagedObjectContext *)context
{
    __block Account *account = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Account"];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"owner" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    if([dict valueForKey:OWNER_KEY])
    {
        request.predicate = [NSPredicate predicateWithFormat:@"owner = %@", [dict valueForKey:OWNER_KEY]];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
            // handle error
        } else if(![matches count]){
            
            [context performBlock:^{
                account = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:context];
                
                account.owner = [dict valueForKey:OWNER_KEY];
            }];
        } else
        {
            account = [matches lastObject];
        }
    }
    account.balance = [dict valueForKey:BALANCE_KEY];
    account.balanceCurrent = [dict valueForKey:BALANCE_CURRENT_KEY];
    account.expirationDate = [dict valueForKey:EXPIRATION_DATE_KEY];
    account.cvv2 = [dict valueForKey:CVV2_KEY];
    account.refreshDate = [NSDate date];
    return account;
}

@end
