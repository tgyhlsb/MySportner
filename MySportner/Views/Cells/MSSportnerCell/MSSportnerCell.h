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

@end

@protocol MSSportnerCellDelegate <NSObject>

- (void)sportnerCell:(MSSportnerCell *)cell didInviteSportner:(MSUser *)sportner;
- (void)sportnerCell:(MSSportnerCell *)cell didUninviteSportner:(MSUser *)sportner;

@end
