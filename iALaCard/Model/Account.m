//
//  Account.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/26/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "Account.h"
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

#define XPATH_QUERY @"//td"

@implementation Account
- (Account *) initWithParser:(TFHpple *) parser
{
    self = [super init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSString *formLabelXpathQueryString = XPATH_QUERY;
    NSArray *formLabelNodes = [parser searchWithXPathQuery:formLabelXpathQueryString];
    for (TFHppleElement *element in formLabelNodes) {
        //NSLog(@"conteudo %@",[[element firstChild] content]);
        if([[[element firstChild] content] isEqualToString:OWNER_DESCRIPTION]){
            
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
    
    [self accountWithDictionary:dict];
    
    self.transactions = [Transaction transactionsWithParser:parser];
    
    return self;
}

- (void) accountWithDictionary:(NSDictionary *) dict
{
    self.owner = [dict valueForKey:OWNER_KEY];
    self.balance = [dict valueForKey:BALANCE_KEY];
    self.balanceCurrent = [dict valueForKey:BALANCE_CURRENT_KEY];
    self.expirationDate = [dict valueForKey:EXPIRATION_DATE_KEY];
    self.cvv2 = [dict valueForKey:CVV2_KEY];
    self.refreshDate = [NSDate date];
}




@end
