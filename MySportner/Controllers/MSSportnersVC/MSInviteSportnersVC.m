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
#import "MSHeaderSectionView.h"
#import "MSColorFactory.h"

typedef NS_ENUM(int, MSInviteSportnerSection) {
    MSInviteSportnerSectionParticipants,
    MSInviteSportnerSectionGuests,
    MSInviteSportnerSectionAllSportners
};

#define SECTION_TITLES @[@"Participants", @"Guests", @"Others"]

@interface MSInviteSportnersVC () <UITableViewDataSource, UITableViewDelegate, MSSportnerCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MBProgressHUD *loadingView;

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
    
    if (self.activity.guests && self.activity.participants && self.activity.awaitings) {
        
    } else {
        [self queryParticipantsAndGuests];
    }
    
    [MSSportnerCell registerToTableview:self.tableView];
}

- (void)queryParticipantsAndGuests
{
    [self.activity querySportnersWithTarget:self callBack:@selector(didLoadGuestsAndParticipantsWithError:)];
}

//- (void)queryOtherSportners
//{
//    [self.activity queryOtherSportnersWithTarger:self callBack:@selector(didLoadOtherSportners:withError:)];
//}

- (void)reloadData
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [indexSet addIndex:0];
    [indexSet addIndex:1];
    [indexSet addIndex:2];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - MSSportnerCellDelegate

- (void)sportnerCell:(MSSportnerCell *)cell didTrigerActionWithSportner:(MSSportner *)sportner
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    switch (indexPath.section) {
        case MSInviteSportnerSectionAllSportners:
            [self sportnerCell:cell didAcceptSportner:sportner];
            break;
        case MSInviteSportnerSectionGuests:
            [self sportnerCell:cell didUninviteSportner:sportner];
            break;
    }
}


- (void)sportnerCell:(MSSportnerCell *)cell didAcceptSportner:(MSSportner *)sportner
{
    [self showLoadingViewInView:self.view];
    PFRelation *particiapentRelation = [self.activity participantRelation];
    [particiapentRelation addObject:sportner];
    PFRelation *awaitingRelation = [self.activity awaitingRelation];
    [awaitingRelation removeObject:sportner];
    [self.activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self addParticipantCallback:cell error:error];
    }];
}

- (void)addParticipantCallback:(MSSportnerCell *)senderCell error:(NSError *)error
{
    [self hideLoadingView];
    if (!error) {
        NSMutableArray *tempAwaitings = [self.activity.awaitings mutableCopy];
        [tempAwaitings removeObject:senderCell.sportner];
        self.activity.awaitings = tempAwaitings;
        
        NSMutableArray *tempGuests = [self.activity.participants mutableCopy];
        [tempGuests insertObject:senderCell.sportner atIndex:0];
        self.activity.guests = tempGuests;

        [self moveSportnerCellToParticipantSection:senderCell];
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

- (void)moveSportnerCellToParticipantSection:(MSSportnerCell *)cell
{
    NSIndexPath *originIndexPath = [self.tableView indexPathForCell:cell];
    NSIndexPath *destinationPath = [NSIndexPath indexPathForRow:0 inSection:MSInviteSportnerSectionParticipants];
    MSSportnerCell *nextCell = (MSSportnerCell *)[self.tableView cellForRowAtIndexPath:destinationPath];
    [self.tableView moveRowAtIndexPath:originIndexPath toIndexPath:destinationPath];
    [cell setActionButtonTitle:nil];
    
    [cell setAppearanceWithOddIndex:!nextCell.oddIndex];
}

- (void)sportnerCell:(MSSportnerCell *)cell didUninviteSportner:(MSSportner *)sportner
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
//        NSMutableArray *tempAllSportners = [self.allSportners mutableCopy];
//        [tempAllSportners insertObject:senderCell.sportner atIndex:0];
//        self.allSportners = tempAllSportners;
        
        NSMutableArray *tempGuests = [self.activity.guests mutableCopy];
        [tempGuests removeObject:senderCell.sportner];
        self.activity.guests = tempGuests;
        
        [self reloadData];
    } else {
        NSString *message = [NSString stringWithFormat:@"Failed to cancel %@ invitation", [senderCell.sportner fullName]];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
    }
}

//- (void)moveSportnerCellToOtherSportnersSection:(MSSportnerCell *)cell
//{
//    NSIndexPath *originIndexPath = [self.tableView indexPathForCell:cell];
//    NSIndexPath *destinationPath = [NSIndexPath indexPathForRow:0 inSection:MSInviteSportnerSectionAllSportners];
//    MSSportnerCell *nextCell = (MSSportnerCell *)[self.tableView cellForRowAtIndexPath:destinationPath];
//    [self.tableView moveRowAtIndexPath:originIndexPath toIndexPath:destinationPath];
//    [cell setActionButtonTitle:nil];
//    
//    [cell setAppearanceWithOddIndex:!nextCell.oddIndex];
//}

#pragma mark - MSActivity Callbacks

- (void)didLoadGuestsAndParticipantsWithError:(NSError *)error
{
    if (!error) {
//        [self.activity queryOtherSportnersWithTarger:self callBack:@selector(didLoadOtherSportners:withError:)];
        [self reloadData];
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Connection failed"];
    }
}

- (void)didLoadOtherSportners:(NSArray *)objects withError:(NSError *)error
{
    if (!error) {
//        self.allSportners = objects;
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
            return [self.activity.awaitings count];
            
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
            MSSportner *sportner = [self.activity.participants objectAtIndex:indexPath.row];
            cell.sportner = sportner;
            [cell setActionButtonHidden:YES];
            break;
        }
        case MSInviteSportnerSectionGuests:
        {
            MSSportner *sportner = [self.activity.guests objectAtIndex:indexPath.row];
            cell.sportner = sportner;
            [cell setActionButtonHidden:NO];
            [cell setActionButtonTitle:@"CANCEL"];
            break;
        }
        case MSInviteSportnerSectionAllSportners:
        {
            MSSportner *sportner = [self.activity.awaitings objectAtIndex:indexPath.row];
            cell.sportner = sportner;
            [cell setActionButtonHidden:NO];
            [cell setActionButtonTitle:@"ACCEPT"];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MSHeaderSectionView *commentHeaderView = [[MSHeaderSectionView alloc] init];
    [commentHeaderView setTitle:[SECTION_TITLES objectAtIndex:section]];
    commentHeaderView.backgroundColor = [MSColorFactory backgroundColorGrayLight];
    return commentHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [SECTION_TITLES objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSSportner *sportner = nil;
    switch (indexPath.section) {
        case MSInviteSportnerSectionParticipants:
        {
            sportner = [self.activity.participants objectAtIndex:indexPath.row];
            break;
        }
            
        case MSInviteSportnerSectionGuests:
        {
            sportner = [self.activity.guests objectAtIndex:indexPath.row];
            break;
        }
            
        case MSInviteSportnerSectionAllSportners:
        {
            sportner = [self.activity.awaitings objectAtIndex:indexPath.row];
            break;
        }
    }
    
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
