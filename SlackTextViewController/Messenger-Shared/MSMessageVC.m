//
//  MessageViewController.m
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "MSMessageVC.h"
#import "MessageTableViewCell.h"
#import "MSComment.h"
#import "MSMessageCell.h"
#import "MSNotificationCenter.h"

#import "LoremIpsum/LoremIpsum.h"

static NSString *MessengerCellIdentifier = @"MessengerCell";
static NSString *AutoCompletionCellIdentifier = @"AutoCompletionCell";

@interface MSMessageVC ()

@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, strong) NSArray *searchResult;

@end

@implementation MSMessageVC

- (id)init
{
    self = [super initWithTableViewStyle:UITableViewStylePlain];
    if (self) {
        [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:MessengerCellIdentifier];
        [MSMessageCell registerToTableView:self.tableView];
        self.title = @"COMMENTS";
    }
    return self;
}

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder
{
    return UITableViewStylePlain;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadMessagesFromActivity];
    
    self.bounces = YES;
    self.undoShakingEnabled = YES;
    self.keyboardPanningEnabled = YES;
    self.inverted = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.textView.placeholder = NSLocalizedString(@"Message", nil);
    self.textView.placeholderColor = [UIColor lightGrayColor];
    self.textView.layer.borderColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0].CGColor;
    self.textView.pastableMediaTypes = SLKPastableMediaTypeAll|SLKPastableMediaTypePassbook;
    
    [self.leftButton setImage:[UIImage imageNamed:@"icn_upload"] forState:UIControlStateNormal];
    [self.leftButton setTintColor:[UIColor grayColor]];
    
    [self.rightButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    
    [self.textInputbar.editorTitle setTextColor:[UIColor darkGrayColor]];
    [self.textInputbar.editortLeftButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [self.textInputbar.editortRightButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    
    self.textInputbar.autoHideRightButton = YES;
    self.textInputbar.maxCharCount = 140;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
    
    self.typingIndicatorView.canResignByTouch = YES;
    
    [self.autoCompletionView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:AutoCompletionCellIdentifier];
//    [self registerPrefixesForAutoCompletion:@[@"@", @"#", @":"]];
    
    [self registerToActivtyNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MSNotificationCenter setObservedActivity:self.activity onScreen:MSObservedActivityScreenComments];
}

#pragma mark - MSActivity

- (void)setActivity:(MSActivity *)activity
{
    _activity = activity;
}

- (void)registerToActivtyNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activityHasBeenUpdated)
                                                 name:MSNotificationActivityStateChanged
                                               object:self.activity];
}

- (void)activityHasBeenUpdated
{
    [self loadMessagesFromActivity];
}

- (void)loadMessagesFromActivity
{
    NSArray *sorted = [self.activity.comments sortedArrayUsingSelector:@selector(compareWithCreationDate:)];
    NSArray *reversed = [[sorted reverseObjectEnumerator] allObjects];
    self.messages = [[NSMutableArray alloc] initWithArray:reversed];
    
    [self.tableView reloadData];
}

- (MSComment *)newMessageWithText:(NSString *)text
{
    MSComment *comment = [[MSComment alloc] init];
    comment.activity = self.activity;
    comment.author = [MSSportner currentSportner];
    comment.content = text;
    
    [self.activity addComment:comment withBlock:^(BOOL succeeded, NSError *error) {
        
    }];
    
    return comment;
}

#pragma mark - Action Methods

- (void)fillWithText:(id)sender
{
    if (self.textView.text.length == 0)
    {
        int sentences = (arc4random() % 4);
        if (sentences <= 1) sentences = 1;
        self.textView.text = [LoremIpsum sentencesWithNumber:sentences];
    }
    else {
        [self.textView slk_insertTextAtCaretRange:[NSString stringWithFormat:@" %@", [LoremIpsum word]]];
    }
}

- (void)simulateUserTyping:(id)sender
{
    if (!self.isEditing && !self.isAutoCompleting) {
        [self.typingIndicatorView insertUsername:[LoremIpsum name]];
    }
}

- (void)editCellMessage:(UIGestureRecognizer *)gesture
{
    MessageTableViewCell *cell = (MessageTableViewCell *)gesture.view;
    MSComment *message = self.messages[cell.indexPath.row];
    
    [self editText:message.content];
    
    [self.tableView scrollToRowAtIndexPath:cell.indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)editRandomMessage:(id)sender
{
    int sentences = (arc4random() % 10);
    if (sentences <= 1) sentences = 1;
    
    [self editText:[LoremIpsum sentencesWithNumber:sentences]];
}

- (void)editLastMessage:(id)sender
{
    if (self.textView.text > 0) {
        return;
    }
    
    NSString *lastMessage = [self.messages firstObject];
    [self editText:lastMessage];
    
    [self.tableView slk_scrollToTopAnimated:YES];
}

- (void)didSaveLastMessageEditing:(id)sender
{
    NSString *message = [self.textView.text copy];
    
    [self.messages removeLastObject];
    [self.messages addObject:message];
    
    [self.tableView reloadData];
}


#pragma mark - Overriden Methods

- (void)didChangeKeyboardStatus:(SLKKeyboardStatus)status
{
    // Notifies the view controller that the keyboard changed status.
}

- (void)textWillUpdate
{
    // Notifies the view controller that the text will update.

    [super textWillUpdate];
}

- (void)textDidUpdate:(BOOL)animated
{
    // Notifies the view controller that the text did update.

    [super textDidUpdate:animated];
}

- (void)didPressLeftButton:(id)sender
{
    // Notifies the view controller when the left button's action has been triggered, manually.
    
    [super didPressLeftButton:sender];
}

- (void)didPressRightButton:(id)sender
{
    // Notifies the view controller when the right button's action has been triggered, manually or by using the keyboard return key.
    
    // This little trick validates any pending auto-correction or auto-spelling just after hitting the 'Send' button
    [self.textView refreshFirstResponder];
    
    MSComment *message = [self newMessageWithText:[self.textView.text copy]];
    
    [self.tableView beginUpdates];
    [self.messages insertObject:message atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    
    [self.tableView slk_scrollToTopAnimated:YES];
    
    [super didPressRightButton:sender];
}

- (void)didPasteMediaContent:(NSDictionary *)userInfo
{
    // Notifies the view controller when the user has pasted an image inside of the text view.
    
    NSLog(@"%s : %@",__FUNCTION__, userInfo);
}

- (void)willRequestUndo
{
    // Notifies the view controller when a user did shake the device to undo the typed text
    
    [super willRequestUndo];
}

- (void)didCommitTextEditing:(id)sender
{
    // Notifies the view controller when tapped on the right "Accept" button for commiting the edited text
    
    NSString *message = [self.textView.text copy];
    
    [self.messages removeObjectAtIndex:0];
    [self.messages insertObject:message atIndex:0];
    [self.tableView reloadData];
    
    [super didCommitTextEditing:sender];
}

- (void)didCancelTextEditing:(id)sender
{
    // Notifies the view controller when tapped on the left "Cancel" button

    [super didCancelTextEditing:sender];
}

- (BOOL)canPressRightButton
{
    return [super canPressRightButton];
}

- (BOOL)canShowAutoCompletion
{
    return NO;
}

- (CGFloat)heightForAutoCompletionView
{
    CGFloat cellHeight = [self.autoCompletionView.delegate tableView:self.autoCompletionView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cellHeight*self.searchResult.count;
}

- (NSArray *)keyCommands
{
    NSMutableArray *commands = [NSMutableArray arrayWithArray:[super keyCommands]];
    
    // Edit last message
    [commands addObject:[UIKeyCommand keyCommandWithInput:UIKeyInputUpArrow
                                           modifierFlags:0
                                                   action:@selector(editLastMessage:)]];
    
    return commands;
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.messages) {
        return 0;
    }
    else {
        if ([tableView isEqual:self.tableView]) {
            return [self.messages count];
        }
        else {
            return [self.searchResult count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        return [self messageCellForRowAtIndexPath:indexPath];
    }
    else {
        return [self autoCompletionCellForRowAtIndexPath:indexPath];
    }
}

- (MSMessageCell *)messageCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [MSMessageCell reusableIdentifier];
    MSMessageCell *cell = (MSMessageCell *)[self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell.textLabel.text) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(editCellMessage:)];
        [cell addGestureRecognizer:longPress];
    }
    
    MSComment *message = self.messages[indexPath.row];
    cell.comment = message;
    cell.indexPath = indexPath;
    
    // Cells must inherit the table view's transform
    // This is very important, since the main table view may be inverted
    cell.transform = self.tableView.transform;
    
    return cell;
}

- (MessageTableViewCell *)autoCompletionCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = (MessageTableViewCell *)[self.autoCompletionView dequeueReusableCellWithIdentifier:AutoCompletionCellIdentifier];
    cell.indexPath = indexPath;
    cell.usedForMessage = NO;

    NSString *item = self.searchResult[indexPath.row];
    
    if ([self.foundPrefix isEqualToString:@"#"]) {
        item = [NSString stringWithFormat:@"# %@", item];
    }
    else if ([self.foundPrefix isEqualToString:@":"]) {
        item = [NSString stringWithFormat:@":%@:", item];
    }
    
    cell.textLabel.text = item;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.numberOfLines = 1;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        MSComment *message = self.messages[indexPath.row];
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                     NSParagraphStyleAttributeName: paragraphStyle};
        
        CGFloat width = CGRectGetWidth(tableView.frame)-(kAvatarSize*2.0+10);
        
        CGRect bounds = [message.content boundingRectWithSize:CGSizeMake(width, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        
        if (message.content.length == 0) {
            return 0.0;
        }
        
        CGFloat height = roundf(CGRectGetHeight(bounds)+kAvatarSize);
        
        if (height < kMinimumHeight) {
            height = kMinimumHeight;
        }
        
        return height + 50;
    }
    else {
        return kMinimumHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.autoCompletionView]) {
        UIView *topView = [UIView new];
        topView.backgroundColor = self.autoCompletionView.separatorColor;
        return topView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.autoCompletionView]) {
        return 0.5;
    }
    return 0.0;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.autoCompletionView]) {
        
        NSMutableString *item = [self.searchResult[indexPath.row] mutableCopy];
        
        if ([self.foundPrefix isEqualToString:@"@"] || [self.foundPrefix isEqualToString:@":"]) {
            [item appendString:@":"];
        }
        
        [item appendString:@" "];
        
        [self acceptAutoCompletionWithString:item];
    }
}


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Since SLKTextViewController uses UIScrollViewDelegate to update a few things, it is important that if you ovveride this method, to call super.
    [super scrollViewDidScroll:scrollView];
}

@end
