//
//  MSSportnersVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 30/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSCenterController.h"
#import "MSSportnerCell.h"
#import "MSActivity.h"

@interface MSSportnersVC : MSCenterController <MSSportnerCellDelegate>
@property (strong, nonatomic) MSActivity *referenceActivity;

+ (MSSportnersVC *)newControler;


- (void)hideLoadingView;
- (void)showLoadingViewInView:(UIView*)v;

@end
