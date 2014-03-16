//
//  MSSportnersVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSSportnersVC.h"
#import "MBProgressHUD.h"
#import "MSProfileVC.h"
#import "MSActivityVC.h"
#import "QBFlatButton.h"
#import "MSStyleFactory.h"

#define NIB_NAME @"MSSportnersVC"

@interface MSSportnersVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MBProgressHUD *loadingView;
@property (weak, nonatomic) IBOutlet QBFlatButton *createActivityButton;

@property (strong, nonatomic) NSArray *data;

@end

@implementation MSSportnersVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = @"SUGGESTED SPORTNERS";
    
    [self querySportners];
    
    [self setUpAppearance];
    
    [MSSportnerCell registerToTableview:self.tableView];
}

+ (MSSportnersVC *)newControler
{
    MSSportnersVC *vc = [[MSSportnersVC alloc] initWithNibName:NIB_NAME bundle:nil];
    vc.hasDirectAccessToDrawer = NO;
    return vc;
}

- (void)setUpAppearance
{
    [self.createActivityButton setTitle:@"CREATE ACTIVITY" forState:UIControlStateNormal];
    [MSStyleFactory setQBFlatButton:self.createActivityButton withStyle:MSFlatButtonStyleGreen];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (IBAction)createActivityButtonHandler:(id)sender
{
    [self showLoadingViewInView:self.navigationController.view];
    [self.referenceActivity saveInBackgroundWithTarget:self selector:@selector(handleActivityCreation:error:)];
}

- (void)handleActivityCreation:(BOOL)succeed error:(NSError *)error
{
    [self hideLoadingView];
    if (!error) {
        [self activityCreationDidSucceed];
    } else {
        NSLog(@"%@", error);
    }
}

- (void)activityCreationDidSucceed
{
    MSActivityVC *destinationVC = [MSActivityVC newController];
    destinationVC.hasDirectAccessToDrawer = YES;
    destinationVC.activity = self.referenceActivity;
    
    [self.navigationController setViewControllers:@[destinationVC] animated:YES];
}

#pragma mark - PARSE Backend

- (void)querySportners
{
    PFQuery *query = [MSSportner query];
    
    if (self.referenceActivity) {
        [query whereKey:@"sports" equalTo:self.referenceActivity.sport.slug];
    }
    
    [self showLoadingViewInView:self.view];
    
    [query findObjectsInBackgroundWithTarget:self
                                    selector:@selector(sportnersCallback:error:)];
}

- (void)sportnersCallback:(NSArray *)objects error:(NSError *)error
{
    [self hideLoadingView];
    if (!error) {
        NSMutableArray *tempObjects = [objects mutableCopy];
        [tempObjects removeObject:[MSSportner currentSportner]];
        self.data = tempObjects;
        [self reloadData];
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}

#pragma mark - MSSportnerCellDelegate

- (void)sportnerCell:(MSSportnerCell *)cell didTrigerActionWithSportner:(MSSportner *)sportner
{
    if ([self.referenceActivity.guests containsObject:sportner]) {
        [self sportnerCell:cell didUninviteSportner:sportner];
    } else {
        [self sportnerCell:cell didInviteSportner:sportner];
    }
}


- (void)sportnerCell:(MSSportnerCell *)cell didInviteSportner:(MSSportner *)sportner
{
    PFRelation *relation = [self.referenceActivity guestRelation];
    [relation addObject:sportner];
    
    NSMutableArray *tempGuests = [self.referenceActivity.guests mutableCopy];
    [tempGuests insertObject:cell.sportner atIndex:0];
    self.referenceActivity.guests = tempGuests;
    
    NSIndexPath *indexPAth = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:@[indexPAth] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)sportnerCell:(MSSportnerCell *)cell didUninviteSportner:(MSSportner *)sportner
{
    PFRelation *relation = [self.referenceActivity guestRelation];
    [relation removeObject:sportner];
    NSMutableArray *tempGuests = [self.referenceActivity.guests mutableCopy];
    [tempGuests removeObject:cell.sportner];
    self.referenceActivity.guests = tempGuests;
    
    NSIndexPath *indexPAth = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:@[indexPAth] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - UITableviewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [MSSportnerCell reusableIdentifier];
    MSSportnerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    MSSportner *sportner = [self.data objectAtIndex:indexPath.row];
    cell.sportner = sportner;
    [cell setAppearanceWithOddIndex:(indexPath.row % 2)];
    cell.delegate = self;
    
    if ([self.referenceActivity.guests containsObject:sportner]) {
        [cell setActionButtonTitle:@"CANCEL"];
    } else {
        [cell setActionButtonTitle:@"INVITE"];
    }
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSSportner *sportner = [self.data objectAtIndex:indexPath.row];
    
    MSProfileVC *destinationVC = [MSProfileVC newController];
    destinationVC.hasDirectAccessToDrawer = NO;
    destinationVC.sportner = sportner;
    
    [self.navigationController pushViewController:destinationVC animated:YES];
}


#pragma mark - MBProgressHUD

- (void)showLoadingViewInView:(UIView*)v
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
