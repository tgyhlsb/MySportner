//
//  MSAttendeesListVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSAttendeesListVC : UIViewController

@property (strong, nonatomic) NSArray *sportnerList;

+ (instancetype)newController;

- (void)startLoading;
- (void)stopLoading;

@end
