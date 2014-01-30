//
//  MSActivityVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSActivityVC.h"
#import "MSGameProfileCell.h"
#import "MSCommentCell.h"
#import "TKAlertCenter.h"
#import "MSProfileVC.h"
#import "MSColorFactory.h"
#import "MSFontFactory.h"
#import "MSInviteSportnersVC.h"
#import "MBProgressHUD.h"

#define COMMENT_TEXTFIELD_MAX_LENGTH 700

#define NIB_NAME @"MSActivityVC"


typedef NS_ENUM(int, MSActivitySection) {
    MSActivitySectionInfo,
//    MSActivitySectionSportners,
    MSActivitySectionComments
};

@interface MSActivityVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MSGameProfileCellDelegate, MSCommentCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBarView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) MSGameProfileCell *infoCell;
@property (strong, nonatomic) MBProgressHUD *loadingView;

@property (nonatomic) BOOL shouldDisplayComments;

@end

@implementation MSActivityVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchComments];
    
    self.title = @"GAME PROFILE";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.commentTextField.delegate = self;
    
    [MSGameProfileCell registerToTableView:self.tableView];
    [MSCommentCell registerToTableView:self.tableView];
    
    self.shouldDisplayComments = NO;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(closeAllResponders)];
    
    [self.view addGestureRecognizer:tap];
    
    [self.commentButton setTitle:@"Send" forState:UIControlStateNormal];
    self.commentTextField.placeholder = @"Write your comment";
    
    if ([self.commentTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [MSColorFactory grayLight];
        self.commentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Write your comment" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName : [MSFontFactory fontForCellSportTitle]}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

+ (MSActivityVC *)newController
{
    MSActivityVC *activityVC = [[MSActivityVC alloc] initWithNibName:NIB_NAME bundle:nil];
    activityVC.hasDirectAccessToDrawer = NO;
    return activityVC;
}

#pragma mark - PFObject & comments

- (IBAction)commentButtonHandler:(id)sender
{
    if ([self.commentTextField.text length] > 0) {
        [self postNewComment];
    }
}

- (void)postNewComment
{
    MSComment *comment = [[MSComment alloc] init];
    comment.content = self.commentTextField.text;
    comment.author = [MSUser currentUser];
    
    [self.activity addComment:comment];
    
    self.commentTextField.text = @"";
    [self.commentTextField resignFirstResponder];
    [self reloadCommentsSection];
    [self scrollTableViewtoLastCell];
}

- (void)fetchComments
{
    [self.activity requestMessagesWithTarget:self callBack:@selector(commentFetchCallBack:error:)];
}

- (void)commentFetchCallBack:(NSArray *)objects error:(NSError *)error
{
    if (error) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Can't load comments"];
    } else {
        self.shouldDisplayComments = YES;
        [self reloadCommentsSection];
    }
}

- (void)reloadCommentsSection
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:MSActivitySectionComments] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == MSActivitySectionComments) {
        return self.shouldDisplayComments ? [[self.activity getComments] count] : 0;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case MSActivitySectionInfo:
        {
            NSString *identifier = [MSGameProfileCell reusableIdentifier];
            self.infoCell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            self.infoCell.activity = self.activity;
            self.infoCell.delegate = self;
            
            self.infoCell.layer.shouldRasterize = YES;
            self.infoCell.layer.rasterizationScale = [UIScreen mainScreen].scale;
            
            return self.infoCell;
        }
        
        case MSActivitySectionComments:
        {
            MSComment *comment = [[self.activity getComments] objectAtIndex:indexPath.row];
            NSString *identifier = [MSCommentCell reusableIdentifierForCommentText:comment.content];
            MSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.delegate = self;
            cell.comment = comment;
            cell.layer.shouldRasterize = YES;
            cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
            return cell;
            
        }
            
        default:
            return nil;
    }
    
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case MSActivitySectionInfo:
            return [MSGameProfileCell height];
        case MSActivitySectionComments:
        {
            MSComment *comment = [[self.activity getComments] objectAtIndex:indexPath.row];
            return [MSCommentCell heightForCommentText:comment.content];
        }
            
        default:
            return 44;
    }
}

#pragma mark MSGameProfileCellDelegate

- (void)gameProfileCell:(MSGameProfileCell *)cell didSelectUser:(MSUser *)user
{
    [self pushToUserProfile:user];
}

- (void)gameProfileCellDidTrigerActionHandler:(MSGameProfileCell *)cell
{
    switch (cell.userMode) {
        case MSGameProfileModeOwner:
        {
            MSInviteSportnersVC *destinationVC = [MSInviteSportnersVC newControler];
            destinationVC.activity = self.activity;
            [self.navigationController pushViewController:destinationVC animated:YES];
            break;
        }
        case MSGameProfileModeParticipant:
        {
            self.infoCell.userMode = MSGameProfileModeLoading;
            [self.activity removeParticipant:[MSUser currentUser] WithTarget:self callBack:@selector(didLeaveActivityWithSuccess:andError:)];
            break;
        }
        case MSGameProfileModeOther:
        {
            self.infoCell.userMode = MSGameProfileModeLoading;
            [self.activity addParticipant:[MSUser currentUser] WithTarget:self callBack:@selector(didJoinActivityWithSuccess:andError:)];
            break;
        }
        case MSGameProfileModeLoading:
        {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Waiting for server response..."];
            break;
        }
        
    }
}

- (void)didJoinActivityWithSuccess:(BOOL)succeed andError:(NSError *)error
{
    if (!error) {
        [self.infoCell setUserMode:MSGameProfileModeParticipant];
    } else {
        [self.infoCell setUserMode:MSGameProfileModeOther];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Connection failed"];
    }
}

- (void)didLeaveActivityWithSuccess:(BOOL)succeed andError:(NSError *)error
{
    if (!error) {
        [self.infoCell setUserMode:MSGameProfileModeOther];
    } else {
        [self.infoCell setUserMode:MSGameProfileModeParticipant];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Connection failed"];
    }
}


#pragma mark - MSCommentCellDelegate

- (void)commentCell:(MSCommentCell *)cell didSelectUser:(MSUser *)user
{
    [self pushToUserProfile:user];
}

- (void)pushToUserProfile:(MSUser *)user
{
    MSProfileVC *destination = [MSProfileVC newController];
    
    destination.user = user;
    destination.hasDirectAccessToDrawer = NO;
    
    [self.navigationController pushViewController:destination animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text length] > 0) {
        [self postNewComment];
        return YES;
    }
    return NO;
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= COMMENT_TEXTFIELD_MAX_LENGTH || returnKey;
}

#pragma mark - Keyboard

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect tempTableViewFrame = self.tableView.frame;
    tempTableViewFrame.size.height = tempTableViewFrame.size.height - kbSize.height;
    
    CGRect tempToolBarFrame = self.tableView.frame;
    tempToolBarFrame = CGRectMake(0, self.view.frame.size.height - kbSize.height - 44, 320, 44);
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.toolBarView setFrame:tempToolBarFrame];
        [self.tableView setFrame:tempTableViewFrame];
    }];
    
    [self scrollTableViewtoLastCell];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect tempTableViewFrame = self.tableView.frame;
    tempTableViewFrame.size.height = tempTableViewFrame.size.height + kbSize.height;
    
    CGRect tempToolBarFrame = self.tableView.frame;
    tempToolBarFrame = CGRectMake(0, self.view.frame.size.height - 44, 320, 44);
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.toolBarView setFrame:tempToolBarFrame];
        [self.tableView setFrame:tempTableViewFrame];
    }];
}

- (void)scrollTableViewtoLastCell
{
    NSInteger row = [self tableView:self.tableView numberOfRowsInSection:MSActivitySectionComments] - 1;
    
    if (row >= 0) {
        NSIndexPath *indexPathBottom = [NSIndexPath indexPathForRow:row inSection:MSActivitySectionComments];
        [self.tableView scrollToRowAtIndexPath:indexPathBottom atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }    
}

- (void)closeAllResponders
{
    [self.commentTextField resignFirstResponder];
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
