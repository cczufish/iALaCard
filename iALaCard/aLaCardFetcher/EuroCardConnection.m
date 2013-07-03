//
//  EuroCardConnection.m
//  iALaCard
//
//  Created by Rodolfo Torres on 7/3/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "EuroCardConnection.h"

@implementation EuroCardConnection

#define TRANSACTION_URL @"https://www.euroticket-alacard.pt/jsp/portlet/c_consumerprogram_home.jsp?section.jsp:section=account&page.jsp:page=consumer/account/c_alltransactions.jsp"
#define ACCOUNT_URL @"https://www.euroticket-alacard.pt/jsp/portlet/c_consumerprogram_home.jsp?page.jsp:page=consumer/account/c_account.jsp&section.jsp:section=account"
#define LOGIN_URL @"http://www.euroticket-alacard.pt/jsp/portlet/c_index.jsp?_reset=true&_portal=www.alacard.pt"
#define LOGOUT_URL @"https://www.euroticket-alacard.pt/jsp/portlet/logout.jsp"

#define LOGIN_KEY @"consumer/jve/c_login.jsp:login_id_form"
#define PASSWORD_KEY @"consumer/jve/c_login.jsp:password_form"

#define SUBMIT @"consumer/jve/c_login.jsp:submit"

#define URL @"www.euroticket-alacard.pt"

- (NSString *) transactionURL
{
    return TRANSACTION_URL;
}

- (NSString *) accountURL
{
    return ACCOUNT_URL;
}

- (NSString *) loginURL
{
    return LOGIN_URL;
}

- (NSString *) logoutURL
{
    return LOGOUT_URL;
}

- (NSString *) loginKey
{
    return LOGIN_KEY;
}

- (NSString *) loginPasswordKey
{
    return PASSWORD_KEY;
}

- (NSString *) loginSubmit
{
    return SUBMIT;
}

- (NSString *) baseURL
{
    return URL;
}

@end
