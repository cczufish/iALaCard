//
//  aLaCardFetcher.m
//  aLaCard
//
//  Created by Rodolfo Torres on 3/17/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "aLaCardFetcher.h"

#define FORM @"//form"
#define ACTION @"action"
#define HIDDEN_FIELDS_XPATH @"//input[@type='hidden']"
#define NAME @"name"
#define VALUE @"value"
#define KEY @"share/key.jsp:KEY"


#define POST @"POST"
#define PORTAL @"_portal"
#define TYPE_CARD @"bes_cartaorefeicao"
#define NOT_EMPTY @"not_empty"
#define PAGE @"page.jsp:page"
#define MEAL_PAGE @"consumer/cartao_refeicao/cartao_refeicao.jsp"


@implementation aLaCardFetcher

+ (NSString *) action:(TFHpple* )parser
{
    NSString *action;
    NSArray *formNodes = [parser searchWithXPathQuery:FORM];
    for (TFHppleElement *element in formNodes) {
        action = [element objectForKey:ACTION];
    }
    return [action stringByReplacingOccurrencesOfString:@":80" withString:@""];
}

+ (NSString *) key:(TFHpple* )parser
{
    NSString *key;
    NSArray *formNodes = [parser searchWithXPathQuery: HIDDEN_FIELDS_XPATH];
    for (TFHppleElement *element in formNodes) {
        NSString *name = [element objectForKey: NAME];
        if([name isEqualToString: KEY]){
            key = [element objectForKey:VALUE];
            break;
        }
    }
    return key;
}

+ (void) logOut
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *logOutUrl = [NSURL URLWithString: [iALaCardConnection sharedALaCardConnectionManager].logoutURL];
    [NSData dataWithContentsOfURL:logOutUrl];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


//log in with args
+ (TFHpple *) logIn:(NSString *) cardNumber andPassword:(NSString *) password
{
    NSLog(@"started logIn");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *logInUrl = [NSURL URLWithString:[iALaCardConnection sharedALaCardConnectionManager].loginURL];
    
    NSData *logInHtmlData = [NSData dataWithContentsOfURL:logInUrl];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if(!logInHtmlData)
    {
        NSLog(@"network error: logInHtmlData NULL");
        return NULL;
    }
    
    TFHpple *logInParser = [TFHpple hppleWithHTMLData:logInHtmlData];
    
    NSString *action = [aLaCardFetcher action:logInParser];
    
    if(action)
    {
        NSURL *url = [[NSURL alloc] initWithString:action];
        NSError *error;
        NSURLResponse *response;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setHTTPMethod:POST];
        [request setURL:url];
        
        NSMutableString *postString = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@=%@", KEY, [aLaCardFetcher key:logInParser]]];
        
        [postString appendFormat:@"&%@=%@", PORTAL, TYPE_CARD];
        [postString appendFormat:@"&%@=%@", [iALaCardConnection sharedALaCardConnectionManager].loginSubmit, NOT_EMPTY];
        [postString appendFormat:@"&%@=%@", PAGE, MEAL_PAGE];
        
        [postString appendFormat:@"&%@=%@", [iALaCardConnection sharedALaCardConnectionManager].loginKey, cardNumber];
        [postString appendFormat:@"&%@=%@", [iALaCardConnection sharedALaCardConnectionManager].loginPasswordKey, password];
        
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        
        NSString *aStr = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
        
        if([[iALaCardConnection sharedALaCardConnectionManager] accountHasChanged:aStr] && [[iALaCardConnection sharedALaCardConnectionManager] isKindOfClass:[OldConnection class]])
        {
            NSLog(@"Eurocard");
            [iALaCardConnection resetToEuroCard];
            return [aLaCardFetcher logIn:cardNumber andPassword:password];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"ended logIn");
        return [TFHpple hppleWithHTMLData:result];
    }
    else{//refresh
        NSLog(@"refresh");
        return logInParser;
    }
}

//returns account page
+(TFHpple *) account
{
    NSLog(@"start account");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *accountUrl = [NSURL URLWithString:[iALaCardConnection sharedALaCardConnectionManager].accountURL];
    NSData *accountHtmlData = [NSData dataWithContentsOfURL:accountUrl];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"end account");
    TFHpple *tf = [TFHpple hppleWithHTMLData:accountHtmlData];
    return tf;
}


//return transactions page
+ (TFHpple *) transactions
{
    NSLog(@"start history");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *transactionsUrl = [NSURL URLWithString:[iALaCardConnection sharedALaCardConnectionManager].transactionURL];
    NSData *transactionsHtmlData = [NSData dataWithContentsOfURL:transactionsUrl];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if(transactionsHtmlData)
    {
        NSLog(@"end history");
        return [TFHpple hppleWithHTMLData:transactionsHtmlData];
    }
    else
    {
        NSLog(@"network error transactionsHtmlData: NULL");
        return NULL;
    }
}


@end
