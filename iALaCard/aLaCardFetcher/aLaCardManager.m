//
//  aLaCardManager.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/30/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "aLaCardManager.h"

@interface aLaCardManager()

@property (nonatomic, assign) BOOL working;

@end

#define CONFIRM_CHANGE_INFO @"/jsp/portlet/consumer/confirm_change_info.jsp"
#define FIRST_LOGIN_DOMAIN @"First Login"

@implementation aLaCardManager

- (BOOL) logIn:(NSString *) cardNumber andPassword:(NSString *) password error:(NSError **) error
{
    TFHpple *rawLogin = [aLaCardFetcher logIn:cardNumber andPassword:password];
    
    if(!rawLogin)
    {
        return NO;
    }
    NSString *action = [aLaCardFetcher action: rawLogin];
    
    if([action isEqual: CONFIRM_CHANGE_INFO])
    {
        [aLaCardFetcher logOut];
        *error = [NSError errorWithDomain: FIRST_LOGIN_DOMAIN code: -1000 userInfo: nil];
        return NO;
    }
    
    if(action == nil)
    {
        if(rawLogin)
        {
            Account *account = [[Account alloc] initWithParser:rawLogin];
            if(account.owner)
            {
                _account = account;
                
            }
            else
            {
                account = [[Account alloc] initWithParser:[aLaCardFetcher account]];
                if(account.owner)
                {
                    _account = account;
                }
                else
                {
                    return NO;
                }
            }
            
            if(![[NSUserDefaults standardUserDefaults] objectForKey:CARD_OWNER_KEY])
            {
                [[NSUserDefaults standardUserDefaults] setObject:account.owner forKey:CARD_OWNER_KEY];
            }
        }
        return  YES;
    }else
    {
        return NO;
    }
}

- (Account *) account
{
    if(!_account)
    {
        [self refreshLogIn];
    }
    
    return _account;
}

- (Transactions *) transactions
{
    TFHpple *parser = [aLaCardFetcher transactions];
    
    if(parser)
    {
        Transactions * trans = [[Transactions alloc] initWithParser:parser];
        
        if(trans.transactionsDictionary.count > 0)
        {
            _transactions = trans;
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showImage:NULL status: CONNECTION_ERROR];
        });
    }
    return _transactions;
}

- (void) refreshLogIn
{
    NSString *cardnumber = [[NSUserDefaults standardUserDefaults] stringForKey:CARD_NUMBER_KEY];
    BOOL refreshStatus = YES;
    if(!self.working)
    {
        self.working = YES;
        refreshStatus = [self logIn:cardnumber andPassword:[SFHFKeychainUtils getPasswordForUsername:cardnumber andServiceName:KEYCHAIN_SERVICE error:nil] error:nil];
        self.working = NO;
    }
    
    if(!refreshStatus)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showImage:NULL status: CONNECTION_ERROR];
        });
    }
}
@end
