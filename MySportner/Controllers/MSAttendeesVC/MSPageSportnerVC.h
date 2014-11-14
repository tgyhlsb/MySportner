//
//  MSAttendeesVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSCenterController.h"
#import "MSSportnerListVC.h"
#import "MSAndroidButton.h"

@interface MSPageSportnerVC : MSCenterController

@property (weak, nonatomic) IBOutlet MSAndroidButton *firstListButton;
@property (weak, nonatomic) IBOutlet MSAndroidButton *secondListButton;
@property (weak, nonatomic) IBOutlet MSAndroidButton *thirdListButton;
@property (strong, nonatomic) NSArray *viewControllers;

- (void)setUpAppearance;
- (void)setViewControllerAtIndex:(NSInteger)index;

- (void)showLoadingViewInView:(UIView*)view;
- (void)hideLoadingView;

@end
