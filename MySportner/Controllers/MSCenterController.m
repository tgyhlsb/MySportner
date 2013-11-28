//
//  MSCenterController.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import "MSCenterController.h"
#import "MMDrawerBarButtonItem.h"

#define TOOLBAR_ALPHA 0.8f

@interface MSCenterController ()

@property (strong, nonatomic) UIToolbar *topToolBar;
@property (strong, nonatomic) UIToolbar *navigationToolBar;

@end

@implementation MSCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLeftMenuButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (UIToolbar *)topToolBar
{
    if (!_topToolBar)
    {
        _topToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        _topToolBar.alpha = TOOLBAR_ALPHA;
    }
    return _topToolBar;
}

- (UIToolbar *)navigationToolBar
{
    if (!_navigationToolBar)
    {
        _navigationToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
        MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
        [_navigationToolBar setItems:@[leftDrawerButton]];
        _navigationToolBar.alpha = TOOLBAR_ALPHA;
    }
    return _navigationToolBar;
}

- (void)setTranslucentNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.view addSubview:self.topToolBar];
    [self.view addSubview:self.navigationToolBar];
}

- (void)setNormalNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.topToolBar removeFromSuperview];
    [self.navigationToolBar removeFromSuperview];
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupRightMenuButton{
    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
}

#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

@end
