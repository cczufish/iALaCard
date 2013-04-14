//
//  TransactionTableViewCell.h
//  iALaCard
//
//  Created by Rodolfo Torres on 3/28/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"
#import "Constants.h"

@interface TransactionTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTransactionDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblValue;

@property (strong, nonatomic) IBOutlet UIImageView *transactionImage;

- (void) setupWithTransaction: (NSObject *) transaction; //HTransaction or Transaction
@end
