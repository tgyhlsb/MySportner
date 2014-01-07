//
//  MSFindFriendsVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 24/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSFindFriendsVC.h"
#import "MSAppDelegate.h"
#import "MBProgressHUD.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MSUser.h"
#import "MSFacebookFriendCell.h"
#import "MSStyleFactory.h"
#import "TKAlertCenter.h"

#define NIB_NAME @"MSFindFriendsVC"

@interface MSFindFriendsVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) MBProgressHUD *loadingView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet QBFlatButton *nextButton;

@property (strong, nonatomic) NSArray *sportners;
@property (strong, nonatomic) NSArray *facebookFriends;

@end

@implementation MSFindFriendsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getFacebookFriends];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = @"FIND FRIENDS";
    
    [MSStyleFactory setQBFlatButton:self.nextButton withStyle:MSFlatButtonStyleGreen];
    [MSFacebookFriendCell registerToTableView:self.tableView];
    
    self.nextButton.hidden = self.hasDirectAccessToDrawer;
}

- (void)performLogin
{
    MSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [appDelegate setDrawerMenu];
    
    [self presentViewController:appDelegate.drawerController animated:YES completion:nil];
}

- (void)setHasDirectAccessToDrawer:(BOOL)hasDirectAccessToDrawer
{
    self.nextButton.hidden = hasDirectAccessToDrawer;
    [super setHasDirectAccessToDrawer:hasDirectAccessToDrawer];
}

- (void)reloadData
{
    [self.tableView reloadData];
    [self hideLoadingView];
    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height + 90);
}

- (void)getFacebookFriends
{
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    
    [self showLoadingViewInView:self.tableView];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        self.facebookFriends = [result objectForKey:@"data"];
        NSMutableArray *facebookIDs = [[NSMutableArray alloc] init];
        
        for (NSDictionary<FBGraphUser>* friend in self.facebookFriends) {
            [facebookIDs addObject:friend.id];
        }
        
        [self getSportnersFromFacebookIDArray:facebookIDs];
    }];
}

- (void)findCallback:(NSArray *)objects error:(NSError *)error
{
    if (!error) {
        self.sportners = objects;
        
        [self reloadData];
    } else {
        // Log details of the failure
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}

- (void)getSportnersFromFacebookIDArray:(NSArray *)facebookIDs
{
    PFQuery *query = [MSUser query];
    [query whereKey:@"facebookID" containedIn:facebookIDs];
    [query findObjectsInBackgroundWithTarget:self
                                    selector:@selector(findCallback:error:)];
}

- (IBAction)validateButtonPress:(UIButton *)sender
{
    if (self.user) {
        [self showLoadingViewInView:self.view];
        [self.user saveInBackgroundWithTarget:self selector:@selector(handleUserSave:error:)];
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Connection lost"];
    }
}
         

- (void)handleUserSave:(NSNumber *)result error:(NSError *)error
{
    [self hideLoadingView];
    if (!error) {
        [self performLogin];
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[error.userInfo objectForKey:@"error"]];
    }
}

+ (MSFindFriendsVC *)newController
{
    MSFindFriendsVC *newVC = [[MSFindFriendsVC alloc] initWithNibName:NIB_NAME bundle:Nil];
    newVC.hasDirectAccessToDrawer = NO;
    return newVC;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.sportners count];
        case 1:
            return [self.facebookFriends count];
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [MSFacebookFriendCell reusableIdentifier];
    MSFacebookFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
        {
            MSUser *sportner = [self.sportners objectAtIndex:indexPath.row];
            cell.titleLabel.text = [sportner fullName];
            break;
        }
        case 1:
        {
            NSDictionary<FBGraphUser>* friend = [self.facebookFriends objectAtIndex:indexPath.row];
            cell.titleLabel.text = [friend.first_name stringByAppendingFormat:@" %@", friend.last_name];
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Friends using MySportner";
        case 1:
            return @"All friends";
            
        default:
            return nil;
    }
}

#pragma mark UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    } else {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//}



#pragma mark - MBProgressHUD

- (void) showLoadingViewInView:(UIView*)v
{
    UIView *targetV = (v ? v : self.view);
    
    if (!self.loadingView) {
        self.loadingView = [[MBProgressHUD alloc] initWithView:targetV];
        self.loadingView.minShowTime = 1.0f;
        self.loadingView.mode = MBProgressHUDModeIndeterminate;
        self.loadingView.removeFromSuperViewOnHide = YES;
        self.loadingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    }
    if(!self.loadingView.superview) {
        self.loadingView.frame = targetV.bounds;
        [targetV addSubview:self.loadingView];
    }
    [self.loadingView show:YES];
}
- (void) hideLoadingView
{
    if (self.loadingView.superview)
        [self.loadingView hide:YES];
}

@end
