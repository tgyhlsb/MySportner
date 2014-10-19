//
//  MSAttendeesVC.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSAttendeesVC.h"
#import "MSAttendeesListVC.h"

#define NIB_NAME @"MSAttendeesVC"

@interface MSAttendeesVC () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *pageViewControllerContainer;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) MSAttendeesListVC *confirmedAttendeesVC;
@property (strong, nonatomic) MSAttendeesListVC *awaitingAttendeesVC;
@property (strong, nonatomic) MSAttendeesListVC *invitedAttendeesVC;

@property (strong, nonatomic) NSArray *viewControllers;

@end

@implementation MSAttendeesVC

+ (instancetype)newController
{
    MSAttendeesVC *controller = [[MSAttendeesVC alloc] initWithNibName:NIB_NAME bundle:nil];
    controller.hasDirectAccessToDrawer = NO;
    return controller;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.title = @"Attendees";
    
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
}

#pragma mark - PageViewController -

- (UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        _pageViewController.view.frame = self.pageViewControllerContainer.bounds;
        [self.pageViewControllerContainer addSubview:_pageViewController.view];
        
        [_pageViewController setViewControllers:@[self.confirmedAttendeesVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
            
        }];
        
        self.viewControllers = @[self.confirmedAttendeesVC, self.awaitingAttendeesVC, self.invitedAttendeesVC];
    }
    return _pageViewController;
}

#pragma mark - AttendeesListControllers

- (MSAttendeesListVC *)confirmedAttendeesVC
{
    if (!_confirmedAttendeesVC) {
        _confirmedAttendeesVC = [MSAttendeesListVC newController];
        _confirmedAttendeesVC.view.backgroundColor = [UIColor redColor];
    }
    return _confirmedAttendeesVC;
}

- (MSAttendeesListVC *)awaitingAttendeesVC
{
    if (!_awaitingAttendeesVC) {
        _awaitingAttendeesVC = [MSAttendeesListVC newController];
        _awaitingAttendeesVC.view.backgroundColor = [UIColor greenColor];
    }
    return _awaitingAttendeesVC;
}

- (MSAttendeesListVC *)invitedAttendeesVC
{
    if (!_invitedAttendeesVC) {
        _invitedAttendeesVC = [MSAttendeesListVC newController];
        _invitedAttendeesVC.view.backgroundColor = [UIColor blueColor];
    }
    return _invitedAttendeesVC;
}

#pragma mark - UIPageViewControllerDatasource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.viewControllers indexOfObject:viewController] - 1;
   
    MSAttendeesListVC *previousController = nil;
    if (index >= 0 && index < [self.viewControllers count]) {
        previousController = (MSAttendeesListVC *)[self.viewControllers objectAtIndex:index];
    }
    
    return previousController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self.viewControllers indexOfObject:viewController] + 1;
    
    MSAttendeesListVC *previousController = nil;
    if (index > 0 && index < [self.viewControllers count]) {
        previousController = (MSAttendeesListVC *)[self.viewControllers objectAtIndex:index];
    }
    
    return previousController;
}

@end
