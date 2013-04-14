//
//  Constants.h
//  iALaCard
//
//  Created by Rodolfo Torres on 3/29/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

//CONTROLS
FOUNDATION_EXPORT NSString *const ACCOUNT_CONTROLLER;
FOUNDATION_EXPORT NSString *const ABOUT_CONTROLLER;
FOUNDATION_EXPORT NSString *const HISTORY_CONTROLLER;

//NSNOTIFICATIONS
FOUNDATION_EXPORT NSString *const DOCUMENT_READY;
FOUNDATION_EXPORT NSString *const LOGIN_DONE;
FOUNDATION_EXPORT NSString *const FILTER_UPDATE;
FOUNDATION_EXPORT NSString *const ACCOUNT_REFRESH;
FOUNDATION_EXPORT NSString *const LOG_OFF;

//IALACARD
FOUNDATION_EXPORT NSString *const CARD_NUMBER_KEY;
FOUNDATION_EXPORT NSString *const CARD_OWNER_KEY;
FOUNDATION_EXPORT NSString *const KEYCHAIN_SERVICE;
FOUNDATION_EXPORT NSString *const TRANSACTION_TYPE_MOVIMENTO;
FOUNDATION_EXPORT NSString *const TRANSACTION_TYPE_CARREGAMENTO;

//UI
FOUNDATION_EXPORT NSString *const LOG_OUT_MSG;
FOUNDATION_EXPORT NSString *const CANCEL_BUTTON;
FOUNDATION_EXPORT NSString *const LEAVE_BUTTON;
FOUNDATION_EXPORT NSString *const CALL_MSG;
FOUNDATION_EXPORT NSString *const CALL_BUTTON;
FOUNDATION_EXPORT NSString *const CALL_ACTION;
FOUNDATION_EXPORT NSString *const EMAIL_MSG;
FOUNDATION_EXPORT NSString *const EMAIL_BUTTON;
FOUNDATION_EXPORT NSString *const EMAIL_ACTION;
FOUNDATION_EXPORT NSString *const WAIT_LOG_IN_MSG;
FOUNDATION_EXPORT NSString *const LOG_IN_OK;
FOUNDATION_EXPORT NSString *const LOG_IN_NOTOK;

FOUNDATION_EXPORT NSString *const LOG_IN_ERROR_TITLE;
FOUNDATION_EXPORT NSString *const LOG_IN_ERROR_MSG;
FOUNDATION_EXPORT NSString *const OK_BUTTON;
FOUNDATION_EXPORT NSString *const CONNECTION_ERROR;
FOUNDATION_EXPORT NSString *const CONNECTION_OK;
FOUNDATION_EXPORT NSString *const CONNECTION_LOST;

//NSDATE
FOUNDATION_EXPORT NSString *const COUNTRY;
FOUNDATION_EXPORT NSString *const UPDATE_LABEL_FORMAT;
FOUNDATION_EXPORT NSString *const SECTION_DATE_FORMAT;
@end
