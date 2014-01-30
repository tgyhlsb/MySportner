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

@property (strong, nonatomic) NSArray *participants;
@property (strong, nonatomic) NSArray *guestSportners;
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
    
    [self querySportners];
    
    [MSSportnerCell registerToTableview:self.tableView];
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
//    [self showLoadingViewInView:nil];
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
        
        NSMutableArray *tempGuests = [self.guestSportners mutableCopy];
        [tempGuests addObject:senderCell.sportner];
        self.guestSportners = tempGuests;
        
        [self reloadData];
    } else {
        NSString *message = [NSString stringWithFormat:@"Failed to invite %@", [senderCell.sportner fullName]];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
    }
}

- (void)sportnerCell:(MSSportnerCell *)cell didUninviteSportner:(MSUser *)sportner
{
//    [self showLoadingViewInView:nil];
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
        [tempAllSportners addObject:senderCell.sportner];
        self.allSportners = tempAllSportners;
        
        NSMutableArray *tempGuests = [self.guestSportners mutableCopy];
        [tempGuests removeObject:senderCell.sportner];
        self.guestSportners = tempGuests;
        
        [self reloadData];
    } else {
        NSString *message = [NSString stringWithFormat:@"Failed to cancel %@ invitation", [senderCell.sportner fullName]];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
    }
}

#pragma mark - PARSE Backend

- (void)querySportners
{
    [self showLoadingViewInView:self.view];
    
    PFQuery *participantQuery = [[self.activity participantRelation] query];
    [participantQuery findObjectsInBackgroundWithTarget:self
                                         selector:@selector(participantsCallback:error:)];
}

- (void)participantsCallback:(NSArray *)objects error:(NSError *)error
{
    if (!error) {
        self.participants = objects;
        
        PFQuery *guestQuery = [[self.activity guestRelation] query];
        [guestQuery findObjectsInBackgroundWithTarget:self
                                             selector:@selector(guestsCallback:error:)];
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}

- (void)guestsCallback:(NSArray *)objects error:(NSError *)error
{
    if (!error) {
        self.guestSportners = objects;
//        NSMutableArray *guestAndParticipants = [self.participants mutableCopy];
//        [guestAndParticipants addObjectsFromArray:self.guestSportners];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", guestAndParticipants];
//        BOOL result = [predicate evaluateWithObject:[self.participants lastObject]];
//        PFQuery *allSportnersQuery = [PFQuery queryWithClassName:@"_USER" predicate:predicate];
        
        
        NSMutableArray *userNames = [[NSMutableArray alloc] initWithCapacity:([self.guestSportners count] + [self.participants count])];
        for (MSUser *guest in self.guestSportners) {
            [userNames addObject:guest.username];
        }
        for (MSUser *participant in self.participants) {
            [userNames addObject:participant.username];
        }
        
        PFQuery *otherSportnersQuery = [MSUser query];
        [otherSportnersQuery whereKey:@"username" notContainedIn:userNames];
        [otherSportnersQuery findObjectsInBackgroundWithTarget:self
                                                    selector:@selector(sportnersCallback:error:)];
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}
     
- (void)sportnersCallback:(NSArray *)objects error:(NSError *)error
{
    [self hideLoadingView];
    if (!error) {
        NSMutableArray *tempObjects = [objects mutableCopy];
//        [tempObjects removeObjectsInArray:self.participants];
//        [tempObjects removeObjectsInArray:self.guestSportners];
        self.allSportners = tempObjects;
        [self reloadData];
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
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
            return [self.participants count];
        case MSInviteSportnerSectionGuests:
            return [self.guestSportners count];
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
            MSUser *sportner = [self.participants objectAtIndex:indexPath.row];
            cell.sportner = sportner;
            [cell setActionButtonHidden:YES];
            break;
        }
        case MSInviteSportnerSectionGuests:
        {
            MSUser *sportner = [self.guestSportners objectAtIndex:indexPath.row];
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
    MSUser *sportner = [self.guestSportners objectAtIndex:indexPath.row];
    
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
