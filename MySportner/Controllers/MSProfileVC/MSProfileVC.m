//
//  MSProfileVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 22/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSProfileVC.h"
#import "MSUser.h"
#import <FacebookSDK/FacebookSDK.h>

#define NIB_NAME @"MSProfileVC"

@interface MSProfileVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *coverPictureView;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;

@end

@implementation MSProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.coverPictureView.image = [UIImage imageNamed:@"runner.jpg"];
    self.profilePictureView.profileID = [MSUser currentUser].facebookID;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTranslucentNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self setNormalNavigationBar];
}


#pragma mark Class methods

+ (MSProfileVC *)newController
{
    return [[MSProfileVC alloc] initWithNibName:NIB_NAME bundle:nil];
}

@end
