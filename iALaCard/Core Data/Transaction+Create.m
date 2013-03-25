//
//  Transaction+Create.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/24/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "Transaction+Create.h"

@implementation Transaction (Create)

+ (NSSet *)transactionsWithParser:(TFHpple *)parser
           inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    //even nodes
    NSString *formLabelXpathQueryString = @"//tr[@class='tablerowalt1']";
    NSArray *formLabelNodes = [parser searchWithXPathQuery:formLabelXpathQueryString];
    
    [self fillDictionary:dict withNodes:formLabelNodes];
    
    //pair nodes
    formLabelXpathQueryString = @"//tr[@class='tablerowalt2']";//even nodes
    formLabelNodes = [parser searchWithXPathQuery:formLabelXpathQueryString];
    
    [self fillDictionary:dict withNodes:formLabelNodes];
    
    return [self transactionsWithDictionary:dict inManagedObjectContext:context];
}


+ (void) fillDictionary: (NSMutableDictionary *) dict withNodes:(NSArray *) nodes
{
    for (TFHppleElement *element in nodes) {
        NSMutableArray *values = [[NSMutableArray alloc] init];
        for(TFHppleElement *child in [element children])
        {
            if([[child firstChild] content])
            {
                [values addObject:[[child firstChild] content]];
                //NSLog(@"conteudo %@",[[child firstChild] content]);
            }
        }
        
        if(values.count == 7)
        {
            [dict setObject:values forKey:values[1]];
        }
    }
}


+ (NSSet *) transactionsWithDictionary: (NSDictionary *) dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSMutableSet *set = [[NSMutableSet alloc]init];
    
    
    for (NSString *key in [dict allKeys]) {
        
        [set addObject:[self transactionWithArray:[dict objectForKey:key]inManagedObjectContext:context]];
    }
    
    return set;
}

+ (Transaction *) transactionWithArray: (NSArray *) array inManagedObjectContext:(NSManagedObjectContext *)context
{
    Transaction *transaction = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Transaction"];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    if(array.count == 7)//magic number
    {
        request.predicate = [NSPredicate predicateWithFormat:@"id = %@", [array[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        // Execute the fetch
        
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
            // handle error
        } else if(![matches count])
        {
            transaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:context];
            
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            
            NSLocale *ptLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_PT"];
            [dateFormat setLocale:ptLocale];
            
            [dateFormat setDateFormat:@"dd/MMM/yy"];
            transaction.date = [dateFormat dateFromString:[array[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            transaction.transactionId = [array[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            transaction.transactionType = [array[2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            transaction.transactionDescription = [array[3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            transaction.debit = [array[4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            transaction.credit = [array[5] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }else
        {
            transaction = [matches lastObject];
        }
    }
    
    return transaction;
}



@end