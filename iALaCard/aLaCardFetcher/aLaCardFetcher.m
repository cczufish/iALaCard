//
//  aLaCardFetcher.m
//  aLaCard
//
//  Created by Rodolfo Torres on 3/17/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "aLaCardFetcher.h"

#define TRANSACTION_URL @"https://www.alacard.pt/jsp/portlet/c_consumerprogram_home.jsp?section.jsp:section=account&page.jsp:page=consumer/account/c_alltransactions.jsp"
#define ACCOUNT_URL @"https://www.alacard.pt/jsp/portlet/c_consumerprogram_home.jsp?page.jsp:page=consumer/account/c_account.jsp&section.jsp:section=account"
#define LOGIN_URL @"https://www.alacard.pt/jsp/portlet/c_index.jsp?_reset=true&_portal=www.alacard.pt"
#define LOGOUT_URL @"https://www.alacard.pt/jsp/portlet/logout.jsp"

#define FORM @"//form"
#define ACTION @"action"
#define HIDDEN_FIELDS_XPATH @"//input[@type='hidden']"
#define NAME @"name"
#define VALUE @"value"
#define KEY @"share/key.jsp:KEY"


#define POST @"POST"
#define PORTAL @"_portal"
#define TYPE_CARD @"bes_cartaorefeicao"
#define SUBMIT @"consumer/cartao_refeicao/c_login.jsp:submit"
#define NOT_EMPTY @"not_empty"
#define PAGE @"page.jsp:page"
#define MEAL_PAGE @"consumer/cartao_refeicao/cartao_refeicao.jsp"
#define LOGIN_KEY @"consumer/cartao_refeicao/c_login.jsp:login_id_form"
#define PASSWORD_KEY @"consumer/cartao_refeicao/c_login.jsp:password_form"


@implementation aLaCardFetcher

+ (NSString *) action:(TFHpple* )parser
{
    NSString *action;
    NSArray *formNodes = [parser searchWithXPathQuery:FORM];
    for (TFHppleElement *element in formNodes) {
        action = [element objectForKey:ACTION];
    }
    return action;
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
    NSURL *logOutUrl = [NSURL URLWithString:LOGOUT_URL];
    [NSData dataWithContentsOfURL:logOutUrl];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


//log in with args
+ (TFHpple *) logIn:(NSString *) cardNumber andPassword:(NSString *) password
{
    NSLog(@"started logIn");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *logInUrl = [NSURL URLWithString:LOGIN_URL];
    
    NSData *logInHtmlData = [NSData dataWithContentsOfURL:logInUrl];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if(!logInHtmlData)
    {
        NSLog(@"network error");
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
        [postString appendFormat:@"&%@=%@", SUBMIT, NOT_EMPTY];
        [postString appendFormat:@"&%@=%@", PAGE, MEAL_PAGE];
        
        [postString appendFormat:@"&%@=%@", LOGIN_KEY, cardNumber];
        [postString appendFormat:@"&%@=%@", PASSWORD_KEY, password];
        
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        //NSString *aStr = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
        //NSLog(@"Result: %@", aStr);
        
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
    NSURL *transactionsUrl = [NSURL URLWithString:ACCOUNT_URL];
    NSData *transactionsHtmlData = [NSData dataWithContentsOfURL:transactionsUrl];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"end account");
    TFHpple *tf = [TFHpple hppleWithHTMLData:transactionsHtmlData];
    return tf;
}


//return transactions page
+ (TFHpple *) transactions
{
    NSLog(@"start history");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *transactionsUrl = [NSURL URLWithString:TRANSACTION_URL];
    NSData *transactionsHtmlData = [NSData dataWithContentsOfURL:transactionsUrl];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if(transactionsHtmlData)
    {
        NSLog(@"end history");
        return [TFHpple hppleWithHTMLData:transactionsHtmlData];
    }
    else
    {
        NSLog(@"network error");
        return NULL;
    }
}


@end
