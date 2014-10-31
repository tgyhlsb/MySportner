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
@protocol MSAttendeesListDelegate;

@interface MSSportnerListVC : UIViewController

@property (weak, nonatomic) id<MSAttendeesListDatasource> datasource;
@property (weak, nonatomic) id<MSAttendeesListDelegate> delegate;

@property (strong, nonatomic) NSArray *sportnerList;
@property (nonatomic) BOOL allowsMultipleSelection;
@property (strong, nonatomic) NSMutableArray *selectedSportners;

+ (instancetype)newController;

- (void)startLoading;
- (void)stopLoading;
- (void)reloadData;

@end

@protocol MSAttendeesListDatasource <NSObject>

- (BOOL)sportnerList:(MSSportnerListVC *)sportListVC shouldDisableCellForSportner:(MSSportner *)sportner;

@end


@protocol MSAttendeesListDelegate <NSObject>

@optional
- (void)sportnerList:(MSSportnerListVC *)sportnerListVC didSelectSportner:(MSSportner *)sportner atIndexPath:(NSIndexPath *)indexPath;

@end
