//
//  MSPlayerSizeView.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 18/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSPlayerSizeView : UIView

@property (nonatomic) NSInteger numberOfPlayer;

+ (MSPlayerSizeView *)viewWithFrame:(CGRect)frame;

@end
