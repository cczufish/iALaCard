//
//  HistoryViewController.m
//  iALaCard
//
//  Created by Rodolfo Torres on 4/7/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableViewHistory;
@property (strong, nonatomic) Transactions *transactions;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) IBOutlet UILabel *lblLastRefresh;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIView *lblLastRefreshView;
@property (strong, nonatomic) NSDateFormatter *formatter;
@end

@implementation HistoryViewController

#define TRANSACTION_CELL @"Transaction"
#define COLOR 0.2863

- (NSDateFormatter *) formatter
{
    if(!_formatter)
    {
        _formatter = [[NSDateFormatter alloc] init];
        NSLocale *ptLocale = [[NSLocale alloc] initWithLocaleIdentifier:COUNTRY];
        [_formatter setLocale:ptLocale];
        
        [_formatter setDateFormat: SECTION_DATE_FORMAT];
    }
    
    return _formatter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFromNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFromNotification) name:LOG_OFF object:nil];
}

- (void) refreshFromNotification
{
    self.transactions = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if(!self.transactions)
    {
        [self refresh];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionKey = [self.sections objectAtIndex:section];
    
    NSArray *transactionsInSection = [self.transactions.transactionsDictionary objectForKey:sectionKey];
    
    return transactionsInSection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransactionTableViewCell *cell = (TransactionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TRANSACTION_CELL];
    if(self.transactions)
    {
        NSArray *transactionsFromSection = [self.transactions.transactionsDictionary objectForKey:[self.sections objectAtIndex:indexPath.section]];
        
        Transaction *transaction = [transactionsFromSection objectAtIndex:indexPath.row];
        
        [cell setupWithTransaction:transaction];
    }
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TableSectionView *tableViewSection =  [[TableSectionView alloc]init];
    
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(10, 0, 300, 23);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor colorWithRed:COLOR green:COLOR blue:COLOR alpha:1];
    
    NSDate *headerDate = (NSDate *)[self.sections objectAtIndex:section];
    headerLabel.text = [self.formatter stringFromDate:headerDate];
    
    [tableViewSection addSubview:headerLabel];
    
    return tableViewSection;
}


-(IBAction) refresh
{
    self.tableViewHistory.alpha = self.lblLastRefreshView.alpha = 0.05;
    if(!self.spinner.isAnimating) //already refreshing
    {
        [self.spinner startAnimating];
        dispatch_async([aLaCardManager sharedQueue], ^{
            self.transactions = [aLaCardManager sharedALaCardManager].transactions;
            NSArray * keys = [self.transactions.transactionsDictionary allKeys];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:FALSE];
            self.sections = [keys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableViewHistory reloadData];
                [self reloadAnimated];
                
                [self.spinner stopAnimating];
            });
        });
    }
}

- (void) reloadAnimated
{
    [UIView animateWithDuration:2.0 animations:^{
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:UPDATE_LABEL_FORMAT];
        
        self.lblLastRefresh.text = [dateFormatter stringFromDate:self.transactions.lastRefreshDate];
        self.tableViewHistory.alpha = 1.0;
        self.lblLastRefreshView.alpha = 1.0;
    }];
}



@end
