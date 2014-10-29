//
//  MSFullScreenPopUpVC.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 18/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MZFormSheetController.h"

@protocol MSFullScreenPopUpDelegate;

@interface MSFullScreenPopUpVC : MZFormSheetController

@property (weak, nonatomic) id<MSFullScreenPopUpDelegate> delegate;

@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *textTitle;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *mainButtonTitle;
@property (strong, nonatomic) NSString *otherButonTitle;

+ (MSFullScreenPopUpVC *)newController;

@end


@protocol MSFullScreenPopUpDelegate <NSObject>

- (void)fullScreenPopUpDidTapMainButton;
- (void)fullScreenPopUpDidTapOtherButton;
- (void)fullScreenPopUpDidTapText;

@end
