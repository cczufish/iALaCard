//
//  aLaCardManager.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/30/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "aLaCardManager.h"

@interface aLaCardManager()

@end

#define CONFIRM_CHANGE_INFO @"/jsp/portlet/consumer/confirm_change_info.jsp"
#define LOGIN_DOMAIN @"Login"

#define PASSWORD_CHANGED_OLD @"https://www.alacard.pt/jsp/portlet/consumer/cartao_refeicao/c_login.jsp"
#define PASSWORD_CHANGED_NEW @"https://www.euroticket-alacard.pt/jsp/portlet/consumer/jve/c_login.jsp"

#define SITE_CHANGED @"SITE_CHANGED"

#define FIRST_TIME_LOGIN_CODE -1000

@implementation aLaCardManager

- (BOOL)LogInErrors:(NSError **)error action:(NSString *)action
{
    if(error != Nil)
    {
        if([action isEqual: CONFIRM_CHANGE_INFO])
        {
            [aLaCardFetcher logOut];
            *error = [NSError errorWithDomain: LOGIN_DOMAIN code: FIRST_TIME_LOGIN_CODE userInfo: nil];
            return NO;
        }
        else if([action isEqual: PASSWORD_CHANGED_NEW] || [action isEqual: PASSWORD_CHANGED_OLD])
        {
            *error = [NSError errorWithDomain: LOGIN_DOMAIN code: PASSWORD_CHANGED_CODE userInfo: nil];
            return NO;
        }
    }
    
    return YES;
}

- (BOOL) logIn:(NSString *) cardNumber andPassword:(NSString *) password error:(NSError **) error
{
    TFHpple *rawLogin = [aLaCardFetcher logIn:cardNumber andPassword:password];
    
    if(!rawLogin)
    {
        return NO;
    }
    
    NSString *action = [aLaCardFetcher action: rawLogin];
    
    
    if([self LogInErrors:error action:action])
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
//                [[NSUserDefaults standardUserDefaults] setObject:account.refreshDate forKey: LAST_REFRESH_DATE_KEY];
            }
        }
        
        return  YES;
    }
    return NO;
}

- (Account *) account
{
    if(!_account)
    {
        [self refreshLogInError:nil];
    }
    
    return _account;
}

- (Transactions *) transactions
{
    [self dispatchToStatusMessage: HISTORY_REFRESH_MSG];
    TFHpple *parser = [aLaCardFetcher transactions];
    
    if(parser)
    {
        Transactions * trans = [[Transactions alloc] initWithParser:parser];
        
        if(trans.transactionsDictionary.count > 0)
        {
            _transactions = trans;
        }
        else
        {
            [self dispatchError:CONNECTION_ERROR];
        }
        
        [self dispatchToStatusDismissWithMessage: HISTORY_REFRESH_MSG AndTime:1];
    }
    else
    {
        [self dispatchError:CONNECTION_ERROR];
    }
    
    return _transactions;
}

- (BOOL) refreshLogInError:(NSError **) error
{
    NSError *refresh;
    NSString *cardnumber = [[NSUserDefaults standardUserDefaults] stringForKey:CARD_NUMBER_KEY];
    
    [self dispatchToStatusMessage:ACCOUNT_REFRESH_MSG];
    
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:cardnumber andServiceName:KEYCHAIN_SERVICE error:nil];
    if (password == nil){
        return [self dispatchPasswordChanged: error];
    }
    
    BOOL refreshStatus = [self logIn:cardnumber andPassword:password error:&refresh];
    
    if(refresh.code == PASSWORD_CHANGED_CODE)
    {
        return [self dispatchPasswordChanged: error];
    }
    else if(!refreshStatus)
    {
        [self dispatchError:CONNECTION_ERROR];
        return NO;
    }
    else
    {
        [self dispatchToStatusDismissWithMessage:ACCOUNT_REFRESH_MSG AndTime:1];
//        [[NSUserDefaults standardUserDefaults] setObject:self.account.refreshDate forKey: LAST_REFRESH_DATE_KEY];
    }
    
    return YES;
}

- (BOOL) dispatchPasswordChanged: (NSError **) error
{
    [self dispatchError:PASSWORD_CHANGED_ERROR];
    if(error != nil){
        *error = [NSError errorWithDomain: LOGIN_DOMAIN code: PASSWORD_CHANGED_CODE userInfo: nil];
    }
    return NO;
}

- (void) logOut
{
    dispatch_async([aLaCardManager sharedQueue], ^{[aLaCardFetcher logOut];});
    
    //delete user defaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CARD_NUMBER_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CARD_OWNER_KEY];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LAST_REFRESH_DATE_KEY];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LOG_OFF object:self userInfo:nil];
}

+ (dispatch_queue_t) sharedQueue
{
    static dispatch_once_t pred;
    static dispatch_queue_t sharedDispatchQueue;
    
    dispatch_once(&pred, ^{
        sharedDispatchQueue = dispatch_queue_create("sharedFetcher", NULL);
    });
    
    return sharedDispatchQueue;
}

-(void) dispatchToStatusMessage: (NSString *) message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [TWStatus showLoadingWithStatus:message];
    });
}

-(void) dispatchError: (NSString *) message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [TWStatus showStatus:message];
    });
    
    [self dispatchToStatusDismissWithMessage: message AndTime:8];
}

-(void) dispatchToStatusDismissWithMessage: (NSString *) message AndTime: (NSTimeInterval) time
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [TWStatus dismissAfter:time WithStatus:message];
    });
}
@end
