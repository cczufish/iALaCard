//
//  aLaCardFetcher.m
//  aLaCard
//
//  Created by Rodolfo Torres on 3/17/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "aLaCardFetcher.h"
#import "SFHFKeychainUtils.h"

#define TRANSACTION_URL @"https://www.alacard.pt/jsp/portlet/c_consumerprogram_home.jsp?section.jsp:section=account&page.jsp:page=consumer/account/c_alltransactions.jsp"

#define ACCOUNT_URL @"https://www.alacard.pt/jsp/portlet/c_consumerprogram_home.jsp?page.jsp:page=consumer/account/c_account.jsp&section.jsp:section=account"

#define LOGIN_URL @"https://www.alacard.pt/jsp/portlet/c_index.jsp?_reset=true&_portal=www.alacard.pt"
#define LOGOUT_URL @"https://www.alacard.pt/jsp/portlet/logout.jsp"

@implementation aLaCardFetcher
+ (NSString *) action:(TFHpple* )parser
{
    NSString *action;
    NSArray *formNodes = [parser searchWithXPathQuery:@"//form"];
    for (TFHppleElement *element in formNodes) {
        action = [element objectForKey:@"action"];
    }
    return action;
}

+ (NSString *) key:(TFHpple* )parser
{
    NSString *key;
    NSArray *formNodes = [parser searchWithXPathQuery:@"//input[@type='hidden']"];
    for (TFHppleElement *element in formNodes) {
        NSString *name = [element objectForKey:@"name"];
        if([name isEqualToString:@"share/key.jsp:KEY"]){
            key = [element objectForKey:@"value"];
            break;
        }
    }
    return key;
}

//performs a getter to check if it needs a login
+(BOOL) needsLogIn
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *logInUrl = [NSURL URLWithString:LOGIN_URL];
    NSData *logInHtmlData = [NSData dataWithContentsOfURL:logInUrl];
    
    //NSString* aStr = [[NSString alloc] initWithData:logInHtmlData encoding:NSASCIIStringEncoding];
    
    //NSLog(@"Result: %@", aStr);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    TFHpple *logInParser = [TFHpple hppleWithHTMLData:logInHtmlData];
    
    NSString *action = [aLaCardFetcher action:logInParser];
    
    return (action != nil);
}

+ (void) logOut
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *logOutUrl = [NSURL URLWithString:LOGIN_URL];
    [NSData dataWithContentsOfURL:logOutUrl];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


//log in with key chain
+ (BOOL) logIn
{
    
    NSString *cardnumber = [[NSUserDefaults standardUserDefaults] stringForKey:CARD_NUMBER_KEY];
    
    if(cardnumber)
    {
        
        return [aLaCardFetcher logIn:cardnumber andPassword:[SFHFKeychainUtils getPasswordForUsername:cardnumber andServiceName:KEYCHAIN_SERVICE error:nil]];
    }
    
    return NO;
}

//log in with args
+ (BOOL) logIn:(NSString *) cardNumber andPassword:(NSString *) password
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *logInUrl = [NSURL URLWithString:LOGIN_URL];
    NSData *logInHtmlData = [NSData dataWithContentsOfURL:logInUrl];
    
    //NSString* aStr = [[NSString alloc] initWithData:logInHtmlData encoding:NSASCIIStringEncoding];
    
    //NSLog(@"Result: %@", aStr);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    TFHpple *logInParser = [TFHpple hppleWithHTMLData:logInHtmlData];
    
    NSString *action = [aLaCardFetcher action:logInParser];
    
    if(action)
    {
        NSURL *url = [[NSURL alloc] initWithString:action];
        NSError *error;
        NSURLResponse *response;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setHTTPMethod:@"POST"];
        [request setURL:url];
        
        NSMutableString *postString = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"share/key.jsp:KEY=%@", [aLaCardFetcher key:logInParser]]];
        
        [postString appendFormat:@"&%@=%@", @"_portal", @"bes_cartaorefeicao"];
        [postString appendFormat:@"&%@=%@", @"consumer/cartao_refeicao/c_login.jsp:submit", @"not_empty"];
        [postString appendFormat:@"&%@=%@", @"page.jsp:page", @"consumer/cartao_refeicao/cartao_refeicao.jsp"];
        
        [postString appendFormat:@"&%@=%@", @"consumer/cartao_refeicao/c_login.jsp:login_id_form", cardNumber];
        [postString appendFormat:@"&%@=%@", @"consumer/cartao_refeicao/c_login.jsp:password_form", password];
        
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        //NSString *aStr = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
        //NSLog(@"Result: %@", aStr);
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        return [aLaCardFetcher action:[TFHpple hppleWithHTMLData:result]] == nil;
    }
    else{//refresh
        return true;
    }
}

//returns account page
+(TFHpple *) account
{
    if([aLaCardFetcher needsLogIn])
    {
        [aLaCardFetcher logIn];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *transactionsUrl = [NSURL URLWithString:ACCOUNT_URL];
    NSData *transactionsHtmlData = [NSData dataWithContentsOfURL:transactionsUrl];
    
    //NSString* aStr = [[NSString alloc] initWithData:transactionsHtmlData encoding:NSASCIIStringEncoding];
    
    //NSLog(@"Result: %@", aStr);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    return [TFHpple hppleWithHTMLData:transactionsHtmlData];
}


//return transactions page
+ (TFHpple *) transactions
{
    if([aLaCardFetcher needsLogIn])
    {
        [aLaCardFetcher logIn];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *transactionsUrl = [NSURL URLWithString:TRANSACTION_URL];
    NSData *transactionsHtmlData = [NSData dataWithContentsOfURL:transactionsUrl];
    
    //NSString* aStr = [[NSString alloc] initWithData:transactionsHtmlData encoding:NSASCIIStringEncoding];
    
    //NSLog(@"transactions: %@", aStr);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    return [TFHpple hppleWithHTMLData:transactionsHtmlData];
}


@end
