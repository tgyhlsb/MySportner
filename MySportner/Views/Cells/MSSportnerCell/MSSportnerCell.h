//
//  MSSportnerCell.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSUser.h"

@protocol MSSportnerCellDelegate;

@interface MSSportnerCell : UITableViewCell

@property (weak, nonatomic) id<MSSportnerCellDelegate> delegate;
@property (strong, nonatomic) MSUser *sportner;


+ (void)registerToTableview:(UITableView *)tableView;

+ (NSString *)reusableIdentifier;

+ (CGFloat)height;

- (void)setAppearanceWithOddIndex:(BOOL)oddIndex;

- (void)setActionButtonHidden:(BOOL)hidden;
- (void)setActionButtonTitle:(NSString *)title;

@end

@protocol MSSportnerCellDelegate <NSObject>

- (void)sportnerCell:(MSSportnerCell *)cell didTrigerActionWithSportner:(MSUser *)sportner;

@end
