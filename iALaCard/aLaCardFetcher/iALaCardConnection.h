//
//  iALaCardConnection.h
//  iALaCard
//
//  Created by Rodolfo Torres on 7/3/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iALaCardConnection : NSObject

- (NSString *) transactionURL;

- (NSString *) accountURL;

- (NSString *) loginURL;

- (NSString *) logoutURL;

- (NSString *) loginKey;

- (NSString *) loginPasswordKey;

- (NSString *) loginSubmit;

- (NSString *) baseURL;

- (BOOL) accountHasChanged:(NSString *) rawPage;
@end
