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

@implementation aLaCardManager

- (BOOL) logIn:(NSString *) cardNumber andPassword:(NSString *) password
{
    TFHpple *rawLogin = [aLaCardFetcher rawlogIn:cardNumber andPassword:password];
    
    if(!rawLogin)
    {
        return NO;
    }
    NSString *action = [aLaCardFetcher action: rawLogin];
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
    _transactions = [[Transactions alloc] initWithParser:[aLaCardFetcher transactions]];
    
    return _transactions;
}

- (BOOL) refreshLogIn
{
    NSString *cardnumber = [[NSUserDefaults standardUserDefaults] stringForKey:CARD_NUMBER_KEY];
    BOOL refreshStatus = YES;
    if(!self.working)
    {
        self.working = YES;
        refreshStatus = [self logIn:cardnumber andPassword:[SFHFKeychainUtils getPasswordForUsername:cardnumber andServiceName:KEYCHAIN_SERVICE error:nil]];
        self.working = NO;
    }
    
    return refreshStatus;
}
@end
