//
//  MSActivitiesVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 22/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSActivitiesVC.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "MSActivity.h"
#import "MSActivityCell.h"
#import "MSActivitiesFilterCell.h"
#import "MSActivityVC.h"
#import "MBProgressHUD.h"
//#import <FacebookSDK/FacebookSDK.h>

#define NIB_NAME @"MSActivitiesVC"

@interface MSActivitiesVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MBProgressHUD *loadingView;

@property (strong, nonatomic) NSArray *data;

@end

@implementation MSActivitiesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestActivitiesFromBackEnd];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.title = @"ACTIVITIES";
    
    [MSActivityCell registerToTableview:self.tableView];
    [MSActivitiesFilterCell registerToTableView:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)generateSampleData
{
    NSMutableArray *tempData = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i++)
    {
        MSActivity *activity = [[MSActivity alloc] init];
        activity.sport = @"Tennis Match";
        activity.place = @"Paris, France";
        [tempData addObject:activity];
    }
    self.data = tempData;
    [self reloadData];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

+ (MSActivitiesVC *)newController
{
    MSActivitiesVC *activitiesVC = [[MSActivitiesVC alloc] initWithNibName:NIB_NAME bundle:nil];
    activitiesVC.hasDirectAccessToDrawer = YES;
    return activitiesVC;
}


#pragma mark Back end process

- (void)activitiesCallback:(NSArray *)objects error:(NSError *)error
{
    if (!error) {
        NSMutableArray *objectsToFetch = [[NSMutableArray alloc] initWithCapacity:[objects count]];
        for (MSActivity *activity in objects)
        {
            [objectsToFetch addObject:activity.owner];
        }
        [PFObject fetchAllIfNeededInBackground:objectsToFetch target:self selector:@selector(ownerCallBack:error:)];
        self.data = objects;
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}

- (void)ownerCallBack:(NSArray *)objects error:(NSError *)error
{
    [self hideLoadingView];
    
    if (!error) {
        [self reloadData];
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}

- (void)requestActivitiesFromBackEnd
{
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASSNAME_ACTIVITY];
    
    [self showLoadingViewInView:self.view];
    
    [query findObjectsInBackgroundWithTarget:self
                                    selector:@selector(activitiesCallback:error:)];
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
            return 1;
        case 1:
            return [self.data count];
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            NSString *identifier = [MSActivitiesFilterCell reusableIdentifier];
            MSActivitiesFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            
            [cell setAppearance];
            
            return cell;
        }
            
        default:
        {
            NSString *identifier = [MSActivityCell reusableIdentifier];
            MSActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            
            MSActivity *activity = [self.data objectAtIndex:indexPath.row];
            
            cell.titleLabel.text = activity.sport;
            cell.placeLabel.text = activity.place;
            cell.ownerNameLabel.text = [activity.owner fullName];
            cell.ownerProfilePictureView.profileID = activity.owner.facebookID;
            
            [cell setAppearanceWithOddIndex:(indexPath.row % 2)];
            return cell;
        }
    }
    
}

#pragma mark UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return [MSActivitiesFilterCell height];
        case 1:
            return [MSActivityCell height];
            
        default:
            return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MSActivityVC *destinationVC = [MSActivityVC newController];
    
    [self.navigationController pushViewController:destinationVC animated:YES];
}



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
