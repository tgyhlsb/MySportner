//
//  MSVenue.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 23/11/2013.
//  Copyright (c) 2013 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSVenue : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (nonatomic) CGPoint location;
@property (nonatomic) CGFloat distance;
@property (nonatomic) NSUInteger postalCode;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *country;

- (id)initWithInfo:(NSDictionary *)info;
+ (MSVenue *)venueWithInfo:(NSDictionary *)info;


@end
