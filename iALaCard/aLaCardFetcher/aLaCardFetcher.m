//
//  aLaCardFetcher.m
//  aLaCard
//
//  Created by Rodolfo Torres on 3/17/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "aLaCardFetcher.h"

#define FORM @"//form[@id='loginform']"
#define ACTION @"action"
#define HIDDEN_FIELDS_XPATH @"//input[@type='hidden']"
#define HIDDEN_FIELDS_XPATH_L @"//form[@id='loginform']/input[@type='hidden']"
#define NAME @"name"
#define VALUE @"value"
#define KEY @"javax.faces.ViewState"


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
    
    TFHppleElement *element = [formNodes firstObject];
    action = [element objectForKey:ACTION];
    
    return action;
}

+ (NSString *) key:(TFHpple* )parser
{
    NSString *key;
    NSArray *formNodes = [parser searchWithXPathQuery: HIDDEN_FIELDS_XPATH_L];
    for (TFHppleElement *element in formNodes) {
        NSString *name = [element objectForKey: NAME];
        if([name isEqualToString: KEY]){
            key = [element objectForKey:VALUE];
            //break;
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
    
    NSData *logInHtmlData = [aLaCardFetcher initLogin];
    
    //oldsite is often down, try the new one
    if(!logInHtmlData)
    {
        NSLog(@"network error: logInHtmlData NULL");
        if([[iALaCardConnection sharedALaCardConnectionManager] isKindOfClass:[OldConnection class]])
        {
            [iALaCardConnection resetToEuroCard];
            return [aLaCardFetcher logIn:cardNumber andPassword:password];            
        }else{ //newsite is down reset
            [iALaCardConnection resetToOld];
            return NULL;
        }
    }
    
    TFHpple *logInParser = [TFHpple hppleWithHTMLData:logInHtmlData];
    
    NSString *action = [aLaCardFetcher action:logInParser];
    
    if(action)
    {
        NSMutableString *urlAction = [[NSMutableString alloc]initWithString: @"https://www.euroticket-alacard.pt"];
        
        [urlAction appendString:action];
        
        NSURL *url = [[NSURL alloc] initWithString:urlAction];
        NSError *error;
        NSURLResponse *response;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setHTTPMethod:POST];
        [request setURL:url];
        
        NSMutableString *postString = [[NSMutableString alloc]initWithString:@"loginform=loginform"];
        
        
        
        [postString appendFormat:@"&%@=%@", [iALaCardConnection sharedALaCardConnectionManager].loginKey, cardNumber];
        [postString appendFormat:@"&%@=%@", [iALaCardConnection sharedALaCardConnectionManager].loginPasswordKey, password];
        
        [postString appendString:@"&loginform:loginButton=Entrar"];
        
        NSString *cleanViewState = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                        (CFStringRef)[aLaCardFetcher key:logInParser],
                                                                                        NULL,
                                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                        kCFStringEncodingUTF8 ));
        
        [postString appendFormat:@"&%@=%@", KEY, cleanViewState];
        
//        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        
//        [request setValue:[NSString stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:@"Content-Length"];
//        
//        [request setHTTPBody:[[postString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
//                              dataUsingEncoding:NSUTF8StringEncoding
//                              allowLossyConversion:NO]];
        
        
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        
//        NSString *aStr = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
        
        NSData *accountHtmlData = [NSData dataWithContentsOfURL:[response URL]];
        
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"ended logIn");
        return [TFHpple hppleWithHTMLData:accountHtmlData];
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

+(NSData *) initLogin
{
    NSData *data;
    NSError *error;
    NSURLResponse *response;
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"GET"];
    NSURL *url = [[NSURL alloc] initWithString:[iALaCardConnection sharedALaCardConnectionManager].loginURL];
    [request setURL:url];
    
    
    
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return data;
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
