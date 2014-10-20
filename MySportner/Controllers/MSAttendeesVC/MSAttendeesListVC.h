//
//  MSAttendeesListVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 19/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSportner.h"

@protocol MSAttendeesListDatasource;

@interface MSAttendeesListVC : UIViewController

@property (weak, nonatomic) id<MSAttendeesListDatasource> datasource;

@property (strong, nonatomic) NSArray *sportnerList;
@property (nonatomic) BOOL allowsMultipleSelection;
@property (strong, nonatomic) NSMutableArray *selectedSportners;

+ (instancetype)newController;

- (void)startLoading;
- (void)stopLoading;
- (void)reloadData;

@end

@protocol MSAttendeesListDatasource <NSObject>

- (BOOL)sportnerList:(MSAttendeesListVC *)sportListVC shouldDisableCellForSportner:(MSSportner *)sportner;

@end
