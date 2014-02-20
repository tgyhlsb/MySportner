//
//  MSReverseGeocodingRequest.h
//  MySportner
//
//  Created by Tanguy Hélesbeux on 13/02/2014.
//  Copyright (c) 2014 MySportner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MSReverseGeocodingRequest : NSObject

+ (void)requestLocation:(CLLocationCoordinate2D)location
                                   completionBlock:(void(^)(NSDictionary *placeInfo, NSError *error))completionBlock;

@end
