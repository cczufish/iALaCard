//
//  Transactions.m
//  iALaCard
//
//  Created by Rodolfo Torres on 4/7/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "Transactions.h"

@implementation Transactions

- (Transactions *) initWithParser:(TFHpple *) parser
{
    self = [super init];
    
    self.transactionsDictionary = [self getSectionedTransactionsFromNodes: [Transaction getNodesFromParser:parser]];
    
    self.lastRefreshDate = [NSDate date];
    
    return self;
}

- (Transactions *) initWithTransactions:(NSMutableArray *) trans
{
    self = [super init];
    
    self.transactionsDictionary = [self getSectionedTransactionsFromTrans: trans];
    
    self.lastRefreshDate = [NSDate date];
    
    return self;
}


//returns transaction sectioned by date
- (NSDictionary * ) getSectionedTransactionsFromTrans: (NSMutableArray *) trans
{
    NSMutableDictionary *sectionedTransactions = [[NSMutableDictionary alloc] init];
    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:FALSE];
//    [trans sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    for (Transaction *transaction in trans) {
        
        NSMutableArray *transactionsForSection = [sectionedTransactions objectForKey:transaction.date];
        
        if(!transactionsForSection) //doesn't contain an transaction object
        {
            transactionsForSection = [[NSMutableArray alloc]init];
            
            [sectionedTransactions setObject:transactionsForSection forKey:transaction.date];
        }
        
        [transactionsForSection addObject:transaction];
    }
    
    return sectionedTransactions;
}


//returns transaction sectioned by date
- (NSDictionary * ) getSectionedTransactionsFromNodes: (NSArray *) nodes
{
    NSMutableDictionary *sectionedTransactions = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *transactions = [[NSMutableDictionary alloc] init];
    
    [self fillDictionary:transactions withNodes:nodes];
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[transactions allKeys]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:FALSE];
    [array sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    for (NSString *key in array) {
        
        Transaction *transaction = [Transaction transactionWithArray:[transactions objectForKey:key]];
        
        NSMutableArray *transactionsForSection = [sectionedTransactions objectForKey:transaction.date];
        
        if(!transactionsForSection) //doesn't contain an transaction object
        {
            transactionsForSection = [[NSMutableArray alloc]init];
            
            [sectionedTransactions setObject:transactionsForSection forKey:transaction.date];
        }
        
        [transactionsForSection addObject:transaction];
    }
    
    return sectionedTransactions;
}

- (void) fillDictionary: (NSMutableDictionary *) dict withNodes:(NSArray *) nodes
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


@end
