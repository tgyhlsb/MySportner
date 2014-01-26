//
//  MSProfileVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 22/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSProfileVC.h"
#import "UIView+MSRoundedView.h"
#import "UIImage+BlurredFrame.h"
#import "MSColorFactory.h"
#import "MSActivityCell.h"
#import "MSActivityVC.h"
#import "MSChooseSportsVC.h"
#import "MSProfilePictureView.h"

#define NIB_NAME @"MSProfileVC"

#define COVER_BLUR_HEIGHT 140

@interface MSProfileVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *coverPictureView;
@property (weak, nonatomic) IBOutlet MSProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation MSProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [MSActivityCell registerToTableview:self.tableView];
    
    [self setAppearance];
    [self reloadView];
}

- (void)setAppearance
{
    [self.profilePictureView setRounded];
    self.profilePictureView.backgroundColor = [UIColor clearColor];
    
    self.locationLabel.textColor = [MSColorFactory whiteLight];
    
    self.userNameLabel.textColor = [MSColorFactory whiteLight];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSportChooser)];
    [self.userNameLabel addGestureRecognizer:tapGesture];
    self.userNameLabel.userInteractionEnabled = YES;
}

- (void)showSportChooser
{
    if ([self.user isEqual:[MSUser currentUser]]) {
        MSChooseSportsVC *destinationVC = [MSChooseSportsVC newController];
        
        destinationVC.user = self.user;
        
        destinationVC.validateBlock = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        
        [self.navigationController pushViewController:destinationVC animated:YES];
        [destinationVC setValidateButtonTitle:@"DONE"];
    }
}

@synthesize user = _user;

- (MSUser *)user
{
    if (!_user) self.user = [MSUser currentUser];
    return _user;
}

- (void)setUser:(MSUser *)user
{
    _user = user;
    
    [self reloadView];
}

- (void)reloadView
{
    if (self.user) {
        [self setCoverPictureWithImage:[UIImage imageNamed:@"runner.jpg"]];
        self.profilePictureView.user = self.user;
        self.userNameLabel.text = [self.user fullName];
        self.locationLabel.text = @"Lyon, France";
    }
}

- (void)setCoverPictureWithImage:(UIImage *)image
{
    CGRect frame = CGRectMake(0, image.size.height - COVER_BLUR_HEIGHT, image.size.width, COVER_BLUR_HEIGHT);
    
    self.coverPictureView.image = [image applyLightEffectAtFrame:frame];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNormalNavigationBar];
    self.navigationItem.title = [[self.user fullName] uppercaseString];
    //[self setTranslucentNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self setNormalNavigationBar];
}


#pragma mark Class methods

+ (MSProfileVC *)newController
{
    MSProfileVC *profileVC = [[MSProfileVC alloc] initWithNibName:NIB_NAME bundle:nil];
    profileVC.hasDirectAccessToDrawer = YES;
    return profileVC;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [MSActivityCell reusableIdentifier];
    MSActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    [cell setAppearanceWithOddIndex:(indexPath.row % 2)];
    return cell;
}

#pragma mark

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MSActivityCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSActivityVC *destinationVC = [MSActivityVC newController];
    
    [self.navigationController pushViewController:destinationVC animated:YES];
}

@end
