//
//  MSAutocompleteRequest.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 18/01/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSAutocompleteRequestDelegate;

@interface MSAutocompleteRequest : NSObject

@property (weak, nonatomic) id <MSAutocompleteRequestDelegate> delegate;

- (void)requestWithString:(NSString *)string andLocation:(CGPoint)location;

@end

@protocol MSAutocompleteRequestDelegate <NSObject>

- (void)autocompleteRequestDidFinishWithPredictions:(NSArray *)predictions;

@end
