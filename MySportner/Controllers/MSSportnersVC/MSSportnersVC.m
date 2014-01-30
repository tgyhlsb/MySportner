//
//  MSSportnersVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSSportnersVC.h"
#import "MSSportnerCell.h"
#import "MBProgressHUD.h"
#import "MSProfileVC.h"

@interface MSSportnersVC () <UITableViewDelegate, UITableViewDataSource, MSSportnerCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MBProgressHUD *loadingView;

@property (strong, nonatomic) NSArray *data;

@end

@implementation MSSportnersVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = @"INVITE SPORTNERS";
    
    [self querySportners];
    
    [MSSportnerCell registerToTableview:self.tableView];
}

+ (MSSportnersVC *)newControler
{
    MSSportnersVC *vc = [[MSSportnersVC alloc] init];
    vc.hasDirectAccessToDrawer = NO;
    return vc;
}

- (void)reloadData
{
    [self.tableView reloadData];
}

#pragma mark - PARSE Backend

- (void)querySportners
{
    PFQuery *query = [MSUser query];
    
    [self showLoadingViewInView:self.view];
    
    [query findObjectsInBackgroundWithTarget:self
                                    selector:@selector(sportnersCallback:error:)];
}

- (void)sportnersCallback:(NSArray *)objects error:(NSError *)error
{
    [self hideLoadingView];
    if (!error) {
        self.data = objects;
        [self reloadData];
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
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
    
    MSUser *sportner = [self.data objectAtIndex:indexPath.row];
    cell.sportner = sportner;
    [cell setAppearanceWithOddIndex:(indexPath.row % 2)];
    cell.delegate = self;
    
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
    MSUser *sportner = [self.data objectAtIndex:indexPath.row];
    
    MSProfileVC *destinationVC = [MSProfileVC newController];
    destinationVC.hasDirectAccessToDrawer = NO;
    destinationVC.user = sportner;
    
    [self.navigationController pushViewController:destinationVC animated:YES];
}

#pragma mark - MSSportnerCellDelegate

- (void)sportnerCell:(MSSportnerCell *)cell didInviteSportner:(MSUser *)sportner
{
    [self showLoadingViewInView:self.tableView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self hideLoadingView];
    });
}

- (void)sportnerCell:(MSSportnerCell *)cell didUninviteSportner:(MSUser *)sportner
{
    
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
