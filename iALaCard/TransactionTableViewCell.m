//
//  TransactionTableViewCell.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/28/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "TransactionTableViewCell.h"

#define BACKGROUND_IMAGE @"barra_tabMovimentos_v1.png"
#define DEBIT_IMAGE @"bolinha_vermelho.png"
#define CREDIT_IMAGE @"bolinha_verde.png"

@implementation TransactionTableViewCell

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed: BACKGROUND_IMAGE];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}


- (void) setupWithTransaction: (Transaction *) transaction
{
    UIImage *image = nil;
    self.lblTransactionDetail.text = transaction.transactionDescription;
    
    if([transaction.transactionType isEqualToString: TRANSACTION_TYPE_MOVIMENTO]){
        self.lblValue.text = transaction.debit;
        image = [UIImage imageNamed: DEBIT_IMAGE];
        
    }else{
        self.lblValue.text = transaction.credit;
        image = [UIImage imageNamed: CREDIT_IMAGE];
    }
    [self.transactionImage setImage:image];
}

@end
