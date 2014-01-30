//
//  MSInviteSportnersVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSInviteSportnersVC.h"
#import "TKAlertCenter.h"
#import "MBProgressHUD.h"
#import "MSSportnerCell.h"
#import "MSProfileVC.h"

typedef NS_ENUM(int, MSInviteSportnerSection) {
    MSInviteSportnerSectionParticipants,
    MSInviteSportnerSectionGuests,
    MSInviteSportnerSectionAllSportners
};

#define SECTION_TITLES @[@"Participants", @"Guests", @"Others"]

@interface MSInviteSportnersVC () <UITableViewDataSource, UITableViewDelegate, MSSportnerCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MBProgressHUD *loadingView;

@property (strong, nonatomic) NSArray *allSportners;

@end

@implementation MSInviteSportnersVC

+ (MSInviteSportnersVC *)newControler
{
    MSInviteSportnersVC *vc = [[MSInviteSportnersVC alloc] init];
    vc.hasDirectAccessToDrawer = NO;
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = @"INVITE SPORTNERS";
    
    if (self.activity.guests && self.activity.participants) {
        [self queryOtherSportners];
    } else {
        [self queryParticipantsAndGuests];
    }
    
    [MSSportnerCell registerToTableview:self.tableView];
}

- (void)queryParticipantsAndGuests
{
    [self.activity querySportnersWithTarget:self callBack:@selector(didLoadGuestsAndParticipantsWithError:)];
}

- (void)queryOtherSportners
{
    [self.activity queryOtherParticipantsWithTarger:self callBack:@selector(didLoadOtherSportners:withError:)];
}

- (void)reloadData
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [indexSet addIndex:0];
    [indexSet addIndex:1];
    [indexSet addIndex:2];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - MSSportnerCellDelegate

- (void)sportnerCell:(MSSportnerCell *)cell didTrigerActionWithSportner:(MSUser *)sportner
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    switch (indexPath.section) {
        case MSInviteSportnerSectionAllSportners:
            [self sportnerCell:cell didInviteSportner:sportner];
            break;
        case MSInviteSportnerSectionGuests:
            [self sportnerCell:cell didUninviteSportner:sportner];
            break;
    }
}


- (void)sportnerCell:(MSSportnerCell *)cell didInviteSportner:(MSUser *)sportner
{
    [self showLoadingViewInView:self.view];
    PFRelation *relation = [self.activity guestRelation];
    [relation addObject:sportner];
    [self.activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self addGuestCallback:cell error:error];
    }];
}

- (void)addGuestCallback:(MSSportnerCell *)senderCell error:(NSError *)error
{
    [self hideLoadingView];
    if (!error) {
        NSMutableArray *tempAllSportners = [self.allSportners mutableCopy];
        [tempAllSportners removeObject:senderCell.sportner];
        self.allSportners = tempAllSportners;
        
        NSMutableArray *tempGuests = [self.activity.guests mutableCopy];
        [tempGuests insertObject:senderCell.sportner atIndex:0];
        self.activity.guests = tempGuests;

        [self moveSportnerCellToGuestSection:senderCell];
    } else {
        NSString *message = [NSString stringWithFormat:@"Failed to invite %@", [senderCell.sportner fullName]];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
    }
}

- (void)moveSportnerCellToGuestSection:(MSSportnerCell *)cell
{
    NSIndexPath *originIndexPath = [self.tableView indexPathForCell:cell];
    NSIndexPath *destinationPath = [NSIndexPath indexPathForRow:0 inSection:MSInviteSportnerSectionGuests];
    MSSportnerCell *nextCell = (MSSportnerCell *)[self.tableView cellForRowAtIndexPath:destinationPath];
    [self.tableView moveRowAtIndexPath:originIndexPath toIndexPath:destinationPath];
    [cell setActionButtonTitle:@"CANCEL"];
    
    [cell setAppearanceWithOddIndex:!nextCell.oddIndex];
}

- (void)sportnerCell:(MSSportnerCell *)cell didUninviteSportner:(MSUser *)sportner
{
    [self showLoadingViewInView:self.view];
    PFRelation *relation = [self.activity guestRelation];
    [relation removeObject:sportner];
    [self.activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self removeGuestCallback:cell error:error];
    }];
}

- (void)removeGuestCallback:(MSSportnerCell *)senderCell error:(NSError *)error
{
    [self hideLoadingView];
    if (!error) {
        NSMutableArray *tempAllSportners = [self.allSportners mutableCopy];
        [tempAllSportners insertObject:senderCell.sportner atIndex:0];
        self.allSportners = tempAllSportners;
        
        NSMutableArray *tempGuests = [self.activity.guests mutableCopy];
        [tempGuests removeObject:senderCell.sportner];
        self.activity.guests = tempGuests;
        [self moveSportnerCellToOtherSportnersSection:senderCell];
    } else {
        NSString *message = [NSString stringWithFormat:@"Failed to cancel %@ invitation", [senderCell.sportner fullName]];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
    }
}

- (void)moveSportnerCellToOtherSportnersSection:(MSSportnerCell *)cell
{
    NSIndexPath *originIndexPath = [self.tableView indexPathForCell:cell];
    NSIndexPath *destinationPath = [NSIndexPath indexPathForRow:0 inSection:MSInviteSportnerSectionAllSportners];
    MSSportnerCell *nextCell = (MSSportnerCell *)[self.tableView cellForRowAtIndexPath:destinationPath];
    [self.tableView moveRowAtIndexPath:originIndexPath toIndexPath:destinationPath];
    [cell setActionButtonTitle:@"INVITE"];
    
    [cell setAppearanceWithOddIndex:!nextCell.oddIndex];
}

#pragma mark - MSActivity Callbacks

- (void)didLoadGuestsAndParticipantsWithError:(NSError *)error
{
    if (!error) {
        [self.activity queryOtherParticipantsWithTarger:self callBack:@selector(didLoadOtherSportners:withError:)];
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Connection failed"];
    }
}

- (void)didLoadOtherSportners:(NSArray *)objects withError:(NSError *)error
{
    if (!error) {
        self.allSportners = objects;
        [self reloadData];
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Connection failed"];
    }
}


#pragma mark - UITableviewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case MSInviteSportnerSectionParticipants:
            return [self.activity.participants count];
        case MSInviteSportnerSectionGuests:
            return [self.activity.guests count];
        case MSInviteSportnerSectionAllSportners:
            return [self.allSportners count];
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [MSSportnerCell reusableIdentifier];
    MSSportnerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    [cell setAppearanceWithOddIndex:(indexPath.row % 2)];
    cell.delegate = self;
    
    switch (indexPath.section) {
        case MSInviteSportnerSectionParticipants:
        {
            MSUser *sportner = [self.activity.participants objectAtIndex:indexPath.row];
            cell.sportner = sportner;
            [cell setActionButtonHidden:YES];
            break;
        }
        case MSInviteSportnerSectionGuests:
        {
            MSUser *sportner = [self.activity.guests objectAtIndex:indexPath.row];
            cell.sportner = sportner;
            [cell setActionButtonHidden:NO];
            [cell setActionButtonTitle:@"CANCEL"];
            break;
        }
        case MSInviteSportnerSectionAllSportners:
        {
            MSUser *sportner = [self.allSportners objectAtIndex:indexPath.row];
            cell.sportner = sportner;
            [cell setActionButtonHidden:NO];
            [cell setActionButtonTitle:@"INVITE"];
            break;
        }
            
        default:
            break;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [SECTION_TITLES objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSUser *sportner = [self.activity.guests objectAtIndex:indexPath.row];
    
    MSProfileVC *destinationVC = [MSProfileVC newController];
    destinationVC.hasDirectAccessToDrawer = NO;
    destinationVC.user = sportner;
    
    [self.navigationController pushViewController:destinationVC animated:YES];
}

#pragma mark - MBProgressHUD

- (void)showLoadingViewInView:(UIView*)v
{
    UIView *targetV = (v ? v : self.view);
    
    if (!self.loadingView) {
        self.loadingView = [[MBProgressHUD alloc] initWithView:targetV];
        self.loadingView.minShowTime = 0.0f;
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
