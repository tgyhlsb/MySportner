//
//  MSLocationPickerVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 31/12/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSLocationPickerDelegate;

@interface MSLocationPickerVC : UIViewController

@property (weak, nonatomic) id <MSLocationPickerDelegate> delegate;

+ (MSLocationPickerVC *)newControler;

@end


@protocol MSLocationPickerDelegate <NSObject>

- (void)didSelectLocation:(NSString *)location;

@end
