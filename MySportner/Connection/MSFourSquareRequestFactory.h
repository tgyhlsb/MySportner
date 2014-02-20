//
//  MSFourSquareRequestFactory.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSURLConnection.h"
#import "MSFourSquareKeyFactory.h"

@interface MSFourSquareRequestFactory : NSObject

+ (MSURLConnection *)requestVenuesNear:(CGPoint)location
                          withCategory:(MSFourSquareCategory)category
                           andDelegate:(id)delegate;
@end
