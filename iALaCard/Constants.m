//
//  Constants.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/29/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "Constants.h"

//CONTROLS
NSString *const STORYBOARD_NAME = @"iPhone";
NSString *const ACCOUNT_CONTROLLER = @"Account";
NSString *const ABOUT_CONTROLLER = @"About";
NSString *const HISTORY_CONTROLLER = @"History";

//NSNOTIFICATIONS
NSString *const ACCOUNT_REFRESH = @"ACCOUNT_REFRESH";
NSString *const LOG_OFF = @"LOG_OFF";
NSString *const SPLASH_I5 = @"Default-568h@2x.png";
NSString *const SPLASH_I4 = @"Default.png";

//IALACARD
NSString *const CARD_NUMBER_KEY = @"CARD_NUMBER_KEY";
NSString *const CARD_NUMBER_KEY2 = @"CARD_NUMBER_KEY2";
NSString *const CARD_OWNER_KEY = @"CARD_OWNER_KEY";
NSString *const KEYCHAIN_SERVICE = @"iALaCardService";
NSString *const TRANSACTION_TYPE_MOVIMENTO = @"Movimento";

//UI
NSString *const LOG_OUT_MSG = @"Deseja sair?";
NSString *const CANCEL_BUTTON = @"Cancelar";
NSString *const LEAVE_BUTTON = @"Sair";
NSString *const CALL_MSG = @"Deseja ligar para o apoio a clientes?";
NSString *const CALL_BUTTON = @"Ligar";
NSString *const CALL_ACTION = @"tel://707500360";
NSString *const EMAIL_MSG = @"Deseja enviar um e-mail para o apoio a clientes?";
NSString *const IALACARD_URL = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=645246676&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
NSString *const EMAIL_BUTTON = @"Enviar e-mail";
NSString *const EMAIL_ACTION = @"mailto:utilizador.pt@edenred.com";
NSString *const WAIT_LOG_IN_MSG = @"validar acesso";
NSString *const LOG_IN_OK = @"aceite";
NSString *const LOG_IN_NOTOK = @"erro no acesso";
NSString *const LOG_IN_ERROR_TITLE = @"Dados de acesso inválidos";
NSString *const LOG_IN_ERROR_MSG = @"Os campos número de cartão e código de acesso são obrigatórios";
NSString *const OK_BUTTON = @"OK";
NSString *const CONNECTION_ERROR = @"erro de ligação";
NSString *const PASSWORD_CHANGED_ERROR = @"código de acesso errado";
NSString *const FIRST_LOG_IN_TITLE = @"Dados incorrectos";

NSString *const FIRST_LOG_IN_MSG = @"Por favor aceda %@ para verificar as suas credenciais.";
NSString *const ACCOUNT_REFRESH_MSG = @"actualizar dados do cartão";
NSString *const HISTORY_REFRESH_MSG = @"actualizar movimentos";

NSString *const COUNTRY = @"pt_PT";
NSString *const UPDATE_LABEL_FORMAT = @"dd/MM/yyyy HH:mm:ss";

NSString *const SECTION_DATE_FORMAT = @"dd MMM, yyyy";
NSString *const LAST_REFRESH_DATE_KEY = @"LAST_REFRESH_DATE_KEY";

@implementation Constants

+(BOOL)isPad
{
#ifdef UI_USER_INTERFACE_IDIOM
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
#endif
    return NO;
}

@end
