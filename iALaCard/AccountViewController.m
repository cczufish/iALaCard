//
//  AccountViewController.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/22/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "AccountViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SFHFKeychainUtils.h"
#import "Account+Create.h"
#import "UIManagedDocument+Shared.h"
#import "aLaCardFetcher.h"

@interface AccountViewController ()
@property (strong, nonatomic) IBOutlet UIView *accountDetailsView;

@property (strong, nonatomic) IBOutlet UILabel *lblOwner;
@property (strong, nonatomic) IBOutlet UILabel *lblNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblBalance;
@property (strong, nonatomic) IBOutlet UILabel *lblBalanceCurrent;

@property (strong, nonatomic) IBOutlet UILabel *lblLastRefreshDate;
@property (strong, nonatomic) IBOutlet UILabel *lblExpirationDate;

@property (strong, nonatomic) IBOutlet UILabel *lblCVV2;

@end

@implementation AccountViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFromNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    
    if(![[NSUserDefaults standardUserDefaults] stringForKey:CARD_NUMBER_KEY])
    {
        [self performSegueWithIdentifier:@"LogIn" sender:nil];
    }
    else
    {
        [self refresh];
    }
}

- (IBAction)flipView
{
    [UIView transitionWithView:self.accountDetailsView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        
                    }
                    completion:NULL];
}

- (IBAction)refreshFromNotification
{
    if(self.view.window)
    {
        [self refresh];
    }
}

-(IBAction) refresh
{
    //    [self.refreshControl beginRefreshing];
    
    
    dispatch_queue_t fetchQ = dispatch_queue_create("fetchAccount", NULL);
    
    NSManagedObjectContext *managedObjectContext = [UIManagedDocument  sharedUIManagedDocument].managedObjectContext;
    
    dispatch_async(fetchQ, ^{
        Account *account = [Account accountWithParser:[aLaCardFetcher account] inManagedObjectContext:managedObjectContext];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(account){
                self.lblOwner.text = account.owner;
                self.lblNumber.text = account.cardNumber;
                self.lblExpirationDate.text = account.expirationDate;
                self.lblBalance.text = account.balance;
                self.lblBalanceCurrent.text = account.balanceCurrent;
                self.lblLastRefreshDate.text = [account.refreshDate description];
                self.lblCVV2.text = account.cvv2;
                self.lblNumber.text = [[[NSUserDefaults standardUserDefaults] objectForKey:CARD_NUMBER_KEY] description];
                
                [self flipView];
            }
            //            [self.refreshControl endRefreshing];
        });
    });
}
@end
