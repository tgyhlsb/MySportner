//
//  MSNotificationCenter.m
//  MySportner
//
//  Created by Tanguy Hélesbeux on 21/10/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import "MSNotificationCenter.h"
#import "CRToast.h"
#import "UIImage+resize.h"

@implementation MSNotificationCenter

+ (void)handleNotification:(NSDictionary *)userInfo
{
    NSString *message = [userInfo objectForKey:@"message"];
    NSString *title = [userInfo objectForKey:@"title"];
    NSString *imageName = [userInfo objectForKey:@"imageName"];
    
    if (!imageName) {
        imageName = @"Icon120.png";
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [UIImage imageWithImage:image scaledToSize:CGSizeMake(30, 30)];
    
    NSMutableDictionary *options = [[MSNotificationCenter options] mutableCopy];
    
    [options setObject:title forKey:kCRToastTextKey];
    [options setObject:message forKey:kCRToastSubtitleTextKey];
    [options setObject:image forKey:kCRToastImageKey];
    
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    NSLog(@"Received notification while app was open");
                                }];
}

+ (NSDictionary *)options
{
    CRToastInteractionResponder *responder = [CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap
                                                                                             automaticallyDismiss:YES
                                                                                                            block:^(CRToastInteractionType interactionType){
                                                                                                                NSLog(@"Dismissed with %@ interaction", NSStringFromCRToastInteractionType(interactionType));
                                                                                                            }];
    
    NSDictionary *options = @{
                              kCRToastAnimationInDirectionKey: @0,
                              kCRToastAnimationInTypeKey: @0,
                              kCRToastAnimationOutDirectionKey: @0,
                              kCRToastAnimationOutTypeKey: @0,
//                              kCRToastImageKey = "<UIImage: 0x7fb0cbc62750>",
                              kCRToastInteractionRespondersKey: @[responder],
                              kCRToastNotificationPresentationTypeKey: @0,
                              kCRToastNotificationTypeKey: @1,
                              kCRToastSubtitleTextAlignmentKey: @0,
                              kCRToastTextAlignmentKey: @0,
                              kCRToastUnderStatusBarKey: @NO,
                              kCRToastBackgroundColorKey: [UIColor colorWithWhite:0 alpha:0.8],
                              kCRToastTextColorKey: [UIColor whiteColor]
                              };
    
    return options;
}

@end
