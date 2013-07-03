//
//  Transaction+Create.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/24/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "Transaction+Create.h"

@implementation Transaction (Create)

+ (NSMutableArray *)transactionsWithParser:(TFHpple *)parser
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [self fillDictionary:dict withNodes:[Transaction getNodesFromParser:parser]];
    
    return [self transactionsWithDictionary:dict];
}


//gets all transaction nodes from parser
+ (NSArray *) getNodesFromParser:(TFHpple *) parser
{
    NSMutableArray *formLabelNodes = [[NSMutableArray alloc]init];
    
    //even nodes
    NSString *formLabelXpathQueryString = XPATH_QUERY_1;
    [formLabelNodes addObjectsFromArray:[parser searchWithXPathQuery:formLabelXpathQueryString]];
    
    //pair nodes
    formLabelXpathQueryString = XPATH_QUERY_2;
    [formLabelNodes addObjectsFromArray:[parser searchWithXPathQuery:formLabelXpathQueryString]];
    
    
    return formLabelNodes;
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


+ (NSMutableArray *) transactionsWithDictionary: (NSDictionary *) dict
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    
    for (NSString *key in [dict allKeys]) {
        
        [array addObject:[self transactionWithArray:[dict objectForKey:key]]];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:TRANSACTION_ID ascending:FALSE];
    [array sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return array;
}


+ (Transaction *) transactionWithArray: (NSArray *) array
{
    Transaction *transaction = [[Transaction alloc] init];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *ptLocale = [[NSLocale alloc] initWithLocaleIdentifier:COUNTRY];
    [dateFormat setLocale:ptLocale];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    
    [dateFormat setDateFormat:DATE_FORMAT];
    transaction.date = [dateFormat dateFromString:[array[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    transaction.transactionId = [f numberFromString:[array[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    transaction.transactionType = [array[2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    transaction.transactionDescription = [array[3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    transaction.debit = [array[4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    transaction.credit = [array[5] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return transaction;
}


@end