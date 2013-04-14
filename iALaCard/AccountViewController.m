//
//  AccountViewController.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/22/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "AccountViewController.h"


@interface AccountViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UILabel *lblOwner;
@property (strong, nonatomic) IBOutlet UILabel *lblNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblBalance;
@property (strong, nonatomic) IBOutlet UILabel *lblBalanceCurrent;
@property (strong, nonatomic) IBOutlet UILabel *lblLastRefreshDate;
@property (strong, nonatomic) IBOutlet UILabel *lblExpirationDate;
@property (strong, nonatomic) IBOutlet UILabel *lblCVV2;
@property (strong, nonatomic) IBOutlet UITableView *recentTransactionsView;
@property (strong, nonatomic) IBOutlet UILabel *lblNoTransactions;
@property (strong, nonatomic) IBOutlet UIView *lblLastRefreshView;
@property (strong, nonatomic) Account *account;

@end

@implementation AccountViewController

#define ANIMATION 2.0
#define TRANSPARENT 0.05
#define LOGIN_SEGUE @"login:"
#define TRANSACTION_CELL @"Transaction"

-(void) viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFromNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //from login
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:ACCOUNT_REFRESH object:nil];
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:CARD_NUMBER_KEY])
    {
        [self refreshFromNotification];
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    
    if(![[NSUserDefaults standardUserDefaults] stringForKey:CARD_NUMBER_KEY])
    {
        [self performSegueWithIdentifier:LOGIN_SEGUE sender:nil];
    }
}



#pragma mark - tableView

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger today = 0;
    if(self.account)
    {
        for (Transaction *transaction in self.account.transactions) {
            if([self last24hoursFrom:transaction.date])
            {
                today++;
            }
        }
        
    }
    
    self.lblNoTransactions.hidden = today != 0;
    
    return today;
}

- (BOOL) last24hoursFrom:(NSDate *) date
{
    int dayNow = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:[NSDate date]];
    int day = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:date];
    
    return dayNow - day <= 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransactionTableViewCell *cell = (TransactionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TRANSACTION_CELL];
    if([aLaCardManager sharedALaCardManager].account)
    {
        Transaction *transaction = [self.account.transactions objectAtIndex:[indexPath row]];
        [cell setupWithTransaction:transaction];
    }
    return cell;
}

#pragma mark - refresh functions

-(IBAction) refresh
{
    self.account = [aLaCardManager sharedALaCardManager].account;
    if(self.account){
        self.lblOwner.text = self.account.owner;
        self.lblNumber.text = self.account.cardNumber;
        self.lblExpirationDate.text = self.account.expirationDate;
        self.lblBalance.text = self.account.balance;
        self.lblBalanceCurrent.text = self.account.balanceCurrent;
        self.lblCVV2.text = self.account.cvv2;
        self.lblNumber.text = [[[NSUserDefaults standardUserDefaults] objectForKey:CARD_NUMBER_KEY] description];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: UPDATE_LABEL_FORMAT];
        
        self.lblLastRefreshDate.text = [dateFormatter stringFromDate:self.account.refreshDate];
        [self reloadDataAnimated];
        
    }
    
    [self.spinner stopAnimating];
}

- (void)refreshFromNotification
{
    if([[NSUserDefaults standardUserDefaults] stringForKey:CARD_NUMBER_KEY])
    {
        [self.spinner startAnimating];
        self.recentTransactionsView.alpha = self.lblBalance.alpha = self.lblBalanceCurrent.alpha = self.lblLastRefreshView.alpha = TRANSPARENT;
        dispatch_queue_t fetchQ = dispatch_queue_create("fetcher", NULL);
        dispatch_async(fetchQ, ^{
            BOOL refreshStatus = [[aLaCardManager sharedALaCardManager] refreshLogIn];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(!refreshStatus)
                {
                    //network error
                    [SVProgressHUD showErrorWithStatus: CONNECTION_ERROR];
                }
                [self refresh];
            });
        });
    }
}

-(void) reloadDataAnimated
{
    [self.recentTransactionsView reloadData];
    
    [UIView animateWithDuration: ANIMATION animations:^{
        self.recentTransactionsView.alpha = self.lblBalance.alpha = self.lblBalanceCurrent.alpha = self.lblLastRefreshView.alpha = 1.0;
    }];
}
@end
