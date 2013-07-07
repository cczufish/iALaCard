//
//  iALaCardConnection.m
//  iALaCard
//
//  Created by Rodolfo Torres on 7/3/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "iALaCardConnection.h"

@implementation iALaCardConnection

- (NSString *) transactionURL {return NULL;}

- (NSString *) accountURL {return NULL;}

- (NSString *) loginURL {return NULL;}

- (NSString *) logoutURL {return NULL;}

- (NSString *) loginKey {return NULL;}

- (NSString *) loginPasswordKey {return NULL;}

- (NSString *) loginSubmit {return NULL;}

- (NSString *) baseURL {return @"ao site do alacard";}

- (BOOL) accountHasChanged:(NSString *)rawPage
{
    return([rawPage rangeOfString:@"Euroticket"].location != NSNotFound || [rawPage rangeOfString:@"Tente novamente!"].location != NSNotFound);
}

@end
